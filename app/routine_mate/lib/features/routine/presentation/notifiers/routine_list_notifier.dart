import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/routine.dart';
import '../../domain/repositories/routine_repository.dart';
import '../states/routine_list_state.dart';

/// 루틴 목록 상태를 관리하는 Notifier
class RoutineListNotifier extends StateNotifier<AsyncValue<RoutineListState>> {
  final RoutineRepository _repository;

  RoutineListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadRoutines();
  }

  /// 루틴 목록을 로드합니다
  Future<void> loadRoutines() async {
    try {
      state = const AsyncValue.loading();

      // 루틴 목록 가져오기
      final routines = await _repository.getAllRoutines();

      // 오늘 날짜의 완료 상태 가져오기
      final todayCompletions = await _getTodayCompletions(routines);

      // 연속 달성 일수 계산
      final streaks = await _calculateStreaks(routines);

      state = AsyncValue.data(RoutineListState(
        routines: routines,
        isInitialLoading: false,
        todayCompletions: todayCompletions,
        streaks: streaks,
      ));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// 루틴을 추가합니다
  Future<void> addRoutine(Routine routine) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    try {
      state = AsyncValue.data(currentState.copyWith(isLoading: true));

      await _repository.createRoutine(routine);
      await loadRoutines(); // 전체 목록 다시 로드
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// 루틴을 업데이트합니다
  Future<void> updateRoutine(Routine routine) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    try {
      state = AsyncValue.data(currentState.copyWith(isLoading: true));

      await _repository.updateRoutine(routine);
      await loadRoutines(); // 전체 목록 다시 로드
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// 루틴을 삭제합니다 (소프트 삭제)
  Future<void> deleteRoutine(String routineId) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    try {
      // Optimistic update: 즉시 UI에서 제거
      final updatedRoutines = currentState.routines
          .where((r) => r.id != routineId)
          .toList();

      state = AsyncValue.data(currentState.copyWith(
        routines: updatedRoutines,
        isLoading: true,
      ));

      await _repository.deleteRoutine(routineId);
      await loadRoutines(); // 전체 목록 다시 로드
    } catch (error, stackTrace) {
      // 실패 시 롤백을 위해 다시 로드
      await loadRoutines();
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// 루틴 완료 상태를 토글합니다 (Optimistic Update)
  Future<void> toggleCompletion(String routineId) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    try {
      // 현재 완료 상태 확인
      final currentStatus = currentState.todayCompletions[routineId] ?? false;
      final newStatus = !currentStatus;

      // Optimistic update: 즉시 UI 업데이트
      final updatedCompletions = {
        ...currentState.todayCompletions,
        routineId: newStatus,
      };

      state = AsyncValue.data(currentState.copyWith(
        todayCompletions: updatedCompletions,
      ));

      // 실제 데이터베이스 업데이트
      final today = DateTime.now();
      if (newStatus) {
        await _repository.markAsCompleted(routineId, today);
      } else {
        await _repository.markAsIncomplete(routineId, today);
      }

      // 연속 달성 일수 재계산
      final streaks = await _calculateStreaks(currentState.routines);
      state = AsyncValue.data(currentState.copyWith(
        streaks: streaks,
      ));
    } catch (error, stackTrace) {
      // 실패 시 롤백
      await loadRoutines();
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// 루틴 순서를 변경합니다
  Future<void> reorderRoutines(int oldIndex, int newIndex) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    try {
      final routines = [...currentState.routines];

      // 순서 변경 로직
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final routine = routines.removeAt(oldIndex);
      routines.insert(newIndex, routine);

      // UI 즉시 업데이트
      state = AsyncValue.data(currentState.copyWith(
        routines: routines,
      ));

      // 데이터베이스에 순서 저장
      final routineIds = routines.map((r) => r.id).toList();
      await _repository.updateRoutineOrder(routineIds);
    } catch (error, stackTrace) {
      // 실패 시 롤백
      await loadRoutines();
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// 필터를 적용합니다
  void setFilter(FilterType filterType) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(
      filterType: filterType,
    ));
  }

  /// 정렬 방식을 변경합니다
  void setSort(SortType sortType) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(
      sortType: sortType,
    ));
  }

  /// 오늘 날짜의 완료 상태를 가져옵니다
  Future<Map<String, bool>> _getTodayCompletions(List<Routine> routines) async {
    final today = DateTime.now();
    final completions = <String, bool>{};

    for (final routine in routines) {
      final status = await _repository.getCompletionStatus(routine.id, today);
      completions[routine.id] = status?.isCompleted ?? false;
    }

    return completions;
  }

  /// 각 루틴의 연속 달성 일수를 계산합니다
  Future<Map<String, int>> _calculateStreaks(List<Routine> routines) async {
    final streaks = <String, int>{};

    for (final routine in routines) {
      final streak = await _repository.getCurrentStreak(routine.id);
      streaks[routine.id] = streak;
    }

    return streaks;
  }

  /// 필터링된 루틴 목록을 반환합니다
  List<Routine> getFilteredRoutines() {
    final currentState = state.valueOrNull;
    if (currentState == null) return [];

    var routines = currentState.routines;
    final today = DateTime.now();

    // 필터 적용
    switch (currentState.filterType) {
      case FilterType.today:
        routines = routines.where((r) => r.isScheduledForDate(today)).toList();
        break;
      case FilterType.completed:
        routines = routines.where((r) =>
          currentState.todayCompletions[r.id] ?? false
        ).toList();
        break;
      case FilterType.incomplete:
        routines = routines.where((r) =>
          !(currentState.todayCompletions[r.id] ?? false)
        ).toList();
        break;
      case FilterType.active:
        routines = routines.where((r) => r.deletedAt == null).toList();
        break;
      case FilterType.archived:
        routines = routines.where((r) => r.deletedAt != null).toList();
        break;
      case FilterType.all:
        break;
    }

    // 정렬 적용
    switch (currentState.sortType) {
      case SortType.name:
        routines.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.created:
        routines.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortType.updated:
        routines.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
      case SortType.completion:
        routines.sort((a, b) {
          final aCompleted = currentState.todayCompletions[a.id] ?? false;
          final bCompleted = currentState.todayCompletions[b.id] ?? false;
          return bCompleted ? 1 : (aCompleted ? -1 : 0);
        });
        break;
      case SortType.streak:
        routines.sort((a, b) {
          final aStreak = currentState.streaks[a.id] ?? 0;
          final bStreak = currentState.streaks[b.id] ?? 0;
          return bStreak.compareTo(aStreak);
        });
        break;
      case SortType.color:
        routines.sort((a, b) => a.colorIndex.compareTo(b.colorIndex));
        break;
      case SortType.custom:
        routines.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        break;
    }

    return routines;
  }
}