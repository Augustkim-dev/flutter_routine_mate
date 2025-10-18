import 'dart:async';
import '../../domain/entities/routine.dart';
import '../../domain/entities/completion_record.dart';
import '../../domain/entities/schedule_type.dart';
import '../../domain/repositories/routine_repository.dart';
import '../datasources/routine_local_datasource.dart';
import '../models/routine_model.dart';
import '../models/completion_record_model.dart';
import '../../../../core/utils/uuid_generator.dart';

/// 루틴 저장소 구현체
class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineLocalDataSource _localDataSource;

  RoutineRepositoryImpl(this._localDataSource);

  @override
  Future<List<Routine>> getAllRoutines() async {
    try {
      final models = await _localDataSource.getAllRoutines();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('루틴 목록을 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<List<Routine>> getAllRoutinesIncludeDeleted() async {
    try {
      final models = await _localDataSource.getAllRoutinesIncludeDeleted();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('모든 루틴 목록을 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<Routine?> getRoutineById(String id) async {
    try {
      final model = await _localDataSource.getRoutineById(id);
      return model?.toEntity();
    } catch (e) {
      throw Exception('루틴을 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<String> createRoutine(Routine routine) async {
    try {
      // 새 루틴에 ID가 없으면 생성
      final newRoutine = routine.id.isEmpty
          ? routine.copyWith(
              id: UuidGenerator.generate(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            )
          : routine;

      final model = RoutineModel.fromEntity(newRoutine);
      return await _localDataSource.insertRoutine(model);
    } catch (e) {
      throw Exception('루틴 생성에 실패했습니다: $e');
    }
  }

  @override
  Future<void> updateRoutine(Routine routine) async {
    try {
      final updatedRoutine = routine.copyWith(updatedAt: DateTime.now());
      final model = RoutineModel.fromEntity(updatedRoutine);
      await _localDataSource.updateRoutine(model);
    } catch (e) {
      throw Exception('루틴 업데이트에 실패했습니다: $e');
    }
  }

  @override
  Future<void> deleteRoutine(String id) async {
    try {
      await _localDataSource.deleteRoutine(id);
    } catch (e) {
      throw Exception('루틴 삭제에 실패했습니다: $e');
    }
  }

  @override
  Future<void> deleteRoutinePermanently(String id) async {
    try {
      await _localDataSource.deleteRoutinePermanently(id);
    } catch (e) {
      throw Exception('루틴 영구 삭제에 실패했습니다: $e');
    }
  }

  @override
  Future<void> updateRoutineOrder(List<String> routineIds) async {
    try {
      await _localDataSource.updateRoutineOrder(routineIds);
    } catch (e) {
      throw Exception('루틴 순서 업데이트에 실패했습니다: $e');
    }
  }

  @override
  Future<void> toggleCompletion(String routineId, DateTime date) async {
    try {
      // 해당 날짜의 완료 기록 확인
      final dateStr = _formatDate(date);
      final records = await _localDataSource.getCompletionRecordsByDateRange(
        routineId,
        date,
        date,
      );

      if (records.isEmpty) {
        // 완료 기록이 없으면 새로 생성
        final record = CompletionRecordModel(
          routineId: routineId,
          date: dateStr,
          isCompleted: 1,
          completedAt: DateTime.now().toIso8601String(),
          createdAt: DateTime.now().toIso8601String(),
        );
        await _localDataSource.upsertCompletionRecord(record);
      } else {
        // 완료 기록이 있으면 토글
        final currentRecord = records.first;
        if (currentRecord.isCompleted == 1) {
          // 완료 -> 미완료: 삭제
          await _localDataSource.deleteCompletionRecord(routineId, date);
        } else {
          // 미완료 -> 완료: 업데이트
          final updatedRecord = currentRecord.copyWith(
            isCompleted: 1,
            completedAt: DateTime.now().toIso8601String(),
          );
          await _localDataSource.upsertCompletionRecord(updatedRecord);
        }
      }
    } catch (e) {
      throw Exception('완료 상태 변경에 실패했습니다: $e');
    }
  }

  @override
  Future<List<CompletionRecord>> getCompletionRecords(String routineId) async {
    try {
      final models = await _localDataSource.getCompletionRecords(routineId);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('완료 기록을 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<List<CompletionRecord>> getCompletionRecordsByDateRange(
    String routineId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final models = await _localDataSource.getCompletionRecordsByDateRange(
        routineId,
        startDate,
        endDate,
      );
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('기간별 완료 기록을 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<Map<String, bool>> getCompletionStatusForDate(DateTime date) async {
    try {
      return await _localDataSource.getCompletionStatusForDate(date);
    } catch (e) {
      throw Exception('날짜별 완료 상태를 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<int> calculateStreak(String routineId) async {
    try {
      final routine = await getRoutineById(routineId);
      if (routine == null) return 0;

      final records = await getCompletionRecords(routineId);
      if (records.isEmpty) return 0;

      // 오늘부터 역순으로 연속 완료일 계산
      int streak = 0;
      DateTime currentDate = DateTime.now();
      currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

      for (int i = 0; i < 365; i++) {
        // 해당 날짜에 루틴이 활성화되어 있는지 확인
        if (!routine.isActiveOnDate(currentDate)) {
          currentDate = currentDate.subtract(const Duration(days: 1));
          continue;
        }

        // 완료 기록 확인
        final isCompleted = records.any((record) {
          final recordDate = DateTime(
            record.date.year,
            record.date.month,
            record.date.day,
          );
          return recordDate == currentDate && record.isCompleted;
        });

        if (isCompleted) {
          streak++;
          currentDate = currentDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }

      return streak;
    } catch (e) {
      throw Exception('스트릭 계산에 실패했습니다: $e');
    }
  }

  @override
  Future<double> calculateCompletionRate(String routineId) async {
    try {
      final routine = await getRoutineById(routineId);
      if (routine == null) return 0.0;

      // 최근 30일간의 완료율 계산
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 29));

      final records = await getCompletionRecordsByDateRange(
        routineId,
        startDate,
        endDate,
      );

      // 활성 날짜 수 계산
      int activeDays = 0;
      int completedDays = 0;

      DateTime currentDate = startDate;
      while (currentDate.isBefore(endDate) || currentDate == endDate) {
        if (routine.isActiveOnDate(currentDate)) {
          activeDays++;

          final isCompleted = records.any((record) {
            final recordDate = DateTime(
              record.date.year,
              record.date.month,
              record.date.day,
            );
            final current = DateTime(
              currentDate.year,
              currentDate.month,
              currentDate.day,
            );
            return recordDate == current && record.isCompleted;
          });

          if (isCompleted) completedDays++;
        }
        currentDate = currentDate.add(const Duration(days: 1));
      }

      return activeDays > 0 ? completedDays / activeDays : 0.0;
    } catch (e) {
      throw Exception('완료율 계산에 실패했습니다: $e');
    }
  }

  @override
  Stream<List<Routine>> watchRoutines() {
    return _localDataSource.watchRoutines().map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Stream<Routine?> watchRoutine(String routineId) {
    return watchRoutines().map((routines) {
      try {
        return routines.firstWhere((routine) => routine.id == routineId);
      } catch (e) {
        return null;
      }
    });
  }

  @override
  Future<void> upsertCompletionRecord(CompletionRecord record) async {
    try {
      final model = CompletionRecordModel.fromEntity(record);
      await _localDataSource.upsertCompletionRecord(model);
    } catch (e) {
      throw Exception('완료 기록 저장에 실패했습니다: $e');
    }
  }

  @override
  Future<void> deleteCompletionRecord(String routineId, DateTime date) async {
    try {
      await _localDataSource.deleteCompletionRecord(routineId, date);
    } catch (e) {
      throw Exception('완료 기록 삭제에 실패했습니다: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> exportData() async {
    try {
      final routines = await getAllRoutinesIncludeDeleted();
      final completionRecords = <String, List<Map<String, dynamic>>>{};

      for (final routine in routines) {
        final records = await getCompletionRecords(routine.id);
        completionRecords[routine.id] = records.map((record) {
          return {
            'date': record.dateString,
            'isCompleted': record.isCompleted,
            'completedAt': record.completedAt?.toIso8601String(),
            'note': record.note,
          };
        }).toList();
      }

      return {
        'version': 1,
        'exportedAt': DateTime.now().toIso8601String(),
        'routines': routines.map((routine) {
          return {
            'id': routine.id,
            'name': routine.name,
            'iconIndex': routine.iconIndex,
            'colorIndex': routine.colorIndex,
            'scheduleType': routine.scheduleType.value,
            'customDays': routine.customDays,
            'sortOrder': routine.sortOrder,
            'reminderTime': routine.reminderTime,
            'isReminderEnabled': routine.isReminderEnabled,
            'createdAt': routine.createdAt.toIso8601String(),
            'updatedAt': routine.updatedAt.toIso8601String(),
            'deletedAt': routine.deletedAt?.toIso8601String(),
          };
        }).toList(),
        'completionRecords': completionRecords,
      };
    } catch (e) {
      throw Exception('데이터 내보내기에 실패했습니다: $e');
    }
  }

  @override
  Future<void> importData(Map<String, dynamic> data) async {
    try {
      // 버전 확인
      final version = data['version'] as int?;
      if (version == null || version > 1) {
        throw Exception('지원하지 않는 데이터 버전입니다');
      }

      // 루틴 가져오기
      final routinesData = data['routines'] as List<dynamic>?;
      if (routinesData != null) {
        for (final routineData in routinesData) {
          final map = routineData as Map<String, dynamic>;
          final routine = Routine(
            id: map['id'] as String,
            name: map['name'] as String,
            iconIndex: map['iconIndex'] as int,
            colorIndex: map['colorIndex'] as int,
            scheduleType: ScheduleType.fromString(map['scheduleType'] as String),
            sortOrder: map['sortOrder'] as int,
            isReminderEnabled: map['isReminderEnabled'] as bool,
            createdAt: DateTime.parse(map['createdAt'] as String),
            updatedAt: DateTime.parse(map['updatedAt'] as String),
            customDays: (map['customDays'] as List<dynamic>?)?.cast<int>(),
            reminderTime: map['reminderTime'] as String?,
            deletedAt: map['deletedAt'] != null
                ? DateTime.parse(map['deletedAt'] as String)
                : null,
          );
          await createRoutine(routine);
        }
      }

      // 완료 기록 가져오기
      final recordsData = data['completionRecords'] as Map<String, dynamic>?;
      if (recordsData != null) {
        for (final entry in recordsData.entries) {
          final routineId = entry.key;
          final records = entry.value as List<dynamic>;

          for (final recordData in records) {
            final map = recordData as Map<String, dynamic>;
            final record = CompletionRecord(
              routineId: routineId,
              date: DateTime.parse(map['date'] as String),
              isCompleted: map['isCompleted'] as bool,
              createdAt: DateTime.now(),
              completedAt: map['completedAt'] != null
                  ? DateTime.parse(map['completedAt'] as String)
                  : null,
              note: map['note'] as String?,
            );
            await upsertCompletionRecord(record);
          }
        }
      }
    } catch (e) {
      throw Exception('데이터 가져오기에 실패했습니다: $e');
    }
  }

  /// 날짜를 문자열로 포맷팅합니다
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Future<CompletionRecord?> getCompletionStatus(String routineId, DateTime date) async {
    try {
      final statusMap = await _localDataSource.getCompletionStatusForDate(date);
      final isCompleted = statusMap[routineId] ?? false;

      if (!isCompleted) return null;

      return CompletionRecord(
        routineId: routineId,
        date: date,
        isCompleted: isCompleted,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('완료 상태 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<void> markAsCompleted(String routineId, DateTime date) async {
    try {
      final record = CompletionRecord(
        routineId: routineId,
        date: date,
        isCompleted: true,
        completedAt: DateTime.now(),
        createdAt: DateTime.now(),
      );
      await upsertCompletionRecord(record);
    } catch (e) {
      throw Exception('완료 표시에 실패했습니다: $e');
    }
  }

  @override
  Future<void> markAsIncomplete(String routineId, DateTime date) async {
    try {
      await deleteCompletionRecord(routineId, date);
    } catch (e) {
      throw Exception('미완료 표시에 실패했습니다: $e');
    }
  }

  @override
  Future<int> getCurrentStreak(String routineId) async {
    // calculateStreak와 동일한 메서드이므로 그대로 호출
    return await calculateStreak(routineId);
  }
}