import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/utils/constants.dart';
import '../models/routine_model.dart';
import '../models/completion_record_model.dart';

/// 루틴 로컬 데이터소스 인터페이스
abstract class RoutineLocalDataSource {
  Future<List<RoutineModel>> getAllRoutines();
  Future<List<RoutineModel>> getAllRoutinesIncludeDeleted();
  Future<RoutineModel?> getRoutineById(String id);
  Future<String> insertRoutine(RoutineModel routine);
  Future<void> updateRoutine(RoutineModel routine);
  Future<void> deleteRoutine(String id);
  Future<void> deleteRoutinePermanently(String id);
  Future<void> updateRoutineOrder(List<String> routineIds);

  Future<List<CompletionRecordModel>> getCompletionRecords(String routineId);
  Future<List<CompletionRecordModel>> getCompletionRecordsByDateRange(
    String routineId,
    DateTime startDate,
    DateTime endDate,
  );
  Future<Map<String, bool>> getCompletionStatusForDate(DateTime date);
  Future<void> upsertCompletionRecord(CompletionRecordModel record);
  Future<void> deleteCompletionRecord(String routineId, DateTime date);

  Stream<List<RoutineModel>> watchRoutines();
}

/// 루틴 로컬 데이터소스 구현체
class RoutineLocalDataSourceImpl implements RoutineLocalDataSource {
  final DatabaseHelper _databaseHelper;
  final _routineStreamController = StreamController<List<RoutineModel>>.broadcast();

  RoutineLocalDataSourceImpl(this._databaseHelper);

  @override
  Future<List<RoutineModel>> getAllRoutines() async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.tableRoutines,
      where: '${AppConstants.columnDeletedAt} IS NULL',
      orderBy: AppConstants.columnSortOrder,
    );

    return maps.map((map) => RoutineModel.fromMap(map)).toList();
  }

  @override
  Future<List<RoutineModel>> getAllRoutinesIncludeDeleted() async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.tableRoutines,
      orderBy: AppConstants.columnSortOrder,
    );

    return maps.map((map) => RoutineModel.fromMap(map)).toList();
  }

  @override
  Future<RoutineModel?> getRoutineById(String id) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.tableRoutines,
      where: '${AppConstants.columnId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return RoutineModel.fromMap(maps.first);
  }

  @override
  Future<String> insertRoutine(RoutineModel routine) async {
    final db = await _databaseHelper.database;
    await db.insert(
      AppConstants.tableRoutines,
      routine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _notifyRoutinesChanged();
    return routine.id;
  }

  @override
  Future<void> updateRoutine(RoutineModel routine) async {
    final db = await _databaseHelper.database;
    final updatedRoutine = routine.copyWith(
      updatedAt: DateTime.now().toIso8601String(),
    );

    await db.update(
      AppConstants.tableRoutines,
      updatedRoutine.toMap(),
      where: '${AppConstants.columnId} = ?',
      whereArgs: [routine.id],
    );
    _notifyRoutinesChanged();
  }

  @override
  Future<void> deleteRoutine(String id) async {
    final db = await _databaseHelper.database;
    await db.update(
      AppConstants.tableRoutines,
      {
        AppConstants.columnDeletedAt: DateTime.now().toIso8601String(),
        AppConstants.columnUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '${AppConstants.columnId} = ?',
      whereArgs: [id],
    );
    _notifyRoutinesChanged();
  }

  @override
  Future<void> deleteRoutinePermanently(String id) async {
    await _databaseHelper.transaction((txn) async {
      // 관련 완료 기록도 함께 삭제
      await txn.delete(
        AppConstants.tableCompletionRecords,
        where: '${AppConstants.columnRoutineId} = ?',
        whereArgs: [id],
      );

      // 루틴 삭제
      await txn.delete(
        AppConstants.tableRoutines,
        where: '${AppConstants.columnId} = ?',
        whereArgs: [id],
      );
    });
    _notifyRoutinesChanged();
  }

  @override
  Future<void> updateRoutineOrder(List<String> routineIds) async {
    await _databaseHelper.transaction((txn) async {
      for (int i = 0; i < routineIds.length; i++) {
        await txn.update(
          AppConstants.tableRoutines,
          {
            AppConstants.columnSortOrder: i,
            AppConstants.columnUpdatedAt: DateTime.now().toIso8601String(),
          },
          where: '${AppConstants.columnId} = ?',
          whereArgs: [routineIds[i]],
        );
      }
    });
    _notifyRoutinesChanged();
  }

  @override
  Future<List<CompletionRecordModel>> getCompletionRecords(String routineId) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.tableCompletionRecords,
      where: '${AppConstants.columnRoutineId} = ?',
      whereArgs: [routineId],
      orderBy: '${AppConstants.columnDate} DESC',
    );

    return maps.map((map) => CompletionRecordModel.fromMap(map)).toList();
  }

  @override
  Future<List<CompletionRecordModel>> getCompletionRecordsByDateRange(
    String routineId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await _databaseHelper.database;
    final startDateStr = _formatDate(startDate);
    final endDateStr = _formatDate(endDate);

    final maps = await db.query(
      AppConstants.tableCompletionRecords,
      where: '${AppConstants.columnRoutineId} = ? AND ${AppConstants.columnDate} >= ? AND ${AppConstants.columnDate} <= ?',
      whereArgs: [routineId, startDateStr, endDateStr],
      orderBy: '${AppConstants.columnDate} DESC',
    );

    return maps.map((map) => CompletionRecordModel.fromMap(map)).toList();
  }

  @override
  Future<Map<String, bool>> getCompletionStatusForDate(DateTime date) async {
    final db = await _databaseHelper.database;
    final dateStr = _formatDate(date);

    final maps = await db.query(
      AppConstants.tableCompletionRecords,
      where: '${AppConstants.columnDate} = ?',
      whereArgs: [dateStr],
    );

    final statusMap = <String, bool>{};
    for (final map in maps) {
      final record = CompletionRecordModel.fromMap(map);
      statusMap[record.routineId] = record.isCompleted == 1;
    }

    return statusMap;
  }

  @override
  Future<void> upsertCompletionRecord(CompletionRecordModel record) async {
    final db = await _databaseHelper.database;
    await db.insert(
      AppConstants.tableCompletionRecords,
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteCompletionRecord(String routineId, DateTime date) async {
    final db = await _databaseHelper.database;
    final dateStr = _formatDate(date);

    await db.delete(
      AppConstants.tableCompletionRecords,
      where: '${AppConstants.columnRoutineId} = ? AND ${AppConstants.columnDate} = ?',
      whereArgs: [routineId, dateStr],
    );
  }

  @override
  Stream<List<RoutineModel>> watchRoutines() {
    // 초기 데이터 로드
    getAllRoutines().then((routines) {
      _routineStreamController.add(routines);
    });

    return _routineStreamController.stream;
  }

  /// 날짜를 문자열로 포맷팅합니다
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// 루틴 변경사항을 스트림에 알립니다
  void _notifyRoutinesChanged() {
    getAllRoutines().then((routines) {
      if (!_routineStreamController.isClosed) {
        _routineStreamController.add(routines);
      }
    });
  }

  /// 리소스를 정리합니다
  void dispose() {
    _routineStreamController.close();
  }
}