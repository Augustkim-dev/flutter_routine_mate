import '../entities/routine.dart';
import '../entities/completion_record.dart';

/// 루틴 저장소 인터페이스 (도메인 레이어)
abstract class RoutineRepository {
  /// 모든 활성 루틴을 가져옵니다
  Future<List<Routine>> getAllRoutines();

  /// 삭제된 루틴을 포함한 모든 루틴을 가져옵니다
  Future<List<Routine>> getAllRoutinesIncludeDeleted();

  /// 특정 ID의 루틴을 가져옵니다
  Future<Routine?> getRoutineById(String id);

  /// 새로운 루틴을 생성합니다
  Future<String> createRoutine(Routine routine);

  /// 루틴을 업데이트합니다
  Future<void> updateRoutine(Routine routine);

  /// 루틴을 삭제합니다 (soft delete)
  Future<void> deleteRoutine(String id);

  /// 루틴을 영구 삭제합니다
  Future<void> deleteRoutinePermanently(String id);

  /// 루틴 순서를 업데이트합니다
  Future<void> updateRoutineOrder(List<String> routineIds);

  /// 특정 날짜의 루틴 완료 상태를 토글합니다
  Future<void> toggleCompletion(String routineId, DateTime date);

  /// 특정 루틴의 완료 기록을 가져옵니다
  Future<List<CompletionRecord>> getCompletionRecords(String routineId);

  /// 특정 날짜 범위의 완료 기록을 가져옵니다
  Future<List<CompletionRecord>> getCompletionRecordsByDateRange(
    String routineId,
    DateTime startDate,
    DateTime endDate,
  );

  /// 특정 날짜의 모든 루틴 완료 상태를 가져옵니다
  Future<Map<String, bool>> getCompletionStatusForDate(DateTime date);

  /// 루틴의 연속 완료 일수(스트릭)를 계산합니다
  Future<int> calculateStreak(String routineId);

  /// 루틴의 완료율을 계산합니다 (최근 30일)
  Future<double> calculateCompletionRate(String routineId);

  /// 루틴 목록의 실시간 변경사항을 감지합니다
  Stream<List<Routine>> watchRoutines();

  /// 특정 루틴의 실시간 변경사항을 감지합니다
  Stream<Routine?> watchRoutine(String routineId);

  /// 완료 기록을 추가 또는 업데이트합니다
  Future<void> upsertCompletionRecord(CompletionRecord record);

  /// 완료 기록을 삭제합니다
  Future<void> deleteCompletionRecord(String routineId, DateTime date);

  /// 모든 데이터를 내보냅니다 (백업용)
  Future<Map<String, dynamic>> exportData();

  /// 데이터를 가져옵니다 (복원용)
  Future<void> importData(Map<String, dynamic> data);

  /// 특정 날짜의 루틴 완료 상태를 가져옵니다
  Future<CompletionRecord?> getCompletionStatus(String routineId, DateTime date);

  /// 루틴을 완료로 표시합니다
  Future<void> markAsCompleted(String routineId, DateTime date);

  /// 루틴을 미완료로 표시합니다
  Future<void> markAsIncomplete(String routineId, DateTime date);

  /// 현재 연속 달성 일수를 가져옵니다
  Future<int> getCurrentStreak(String routineId);
}