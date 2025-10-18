import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/repository_provider.dart';
import '../states/routine_list_state.dart';
import '../notifiers/routine_list_notifier.dart';
import '../../domain/entities/routine.dart';

/// 루틴 리스트 상태를 관리하는 Provider
final routineListProvider = StateNotifierProvider<RoutineListNotifier, AsyncValue<RoutineListState>>((ref) {
  final repository = ref.watch(routineRepositoryProvider);
  return RoutineListNotifier(repository);
});

/// 필터링 및 정렬된 루틴 목록을 제공하는 Provider
final filteredRoutinesProvider = Provider<List<Routine>>((ref) {
  final state = ref.watch(routineListProvider);

  return state.maybeWhen(
    data: (listState) {
      final notifier = ref.read(routineListProvider.notifier);
      return notifier.getFilteredRoutines();
    },
    orElse: () => [],
  );
});

/// 오늘 할 루틴 목록을 제공하는 Provider
final todayRoutinesProvider = Provider<List<Routine>>((ref) {
  final state = ref.watch(routineListProvider);
  final today = DateTime.now();

  return state.maybeWhen(
    data: (listState) {
      return listState.routines
          .where((routine) => routine.isScheduledForDate(today))
          .toList();
    },
    orElse: () => [],
  );
});

/// 오늘 완료한 루틴 개수를 제공하는 Provider
final todayCompletedCountProvider = Provider<int>((ref) {
  final state = ref.watch(routineListProvider);

  return state.maybeWhen(
    data: (listState) {
      int count = 0;
      final today = DateTime.now();

      for (final routine in listState.routines) {
        if (routine.isScheduledForDate(today)) {
          if (listState.todayCompletions[routine.id] ?? false) {
            count++;
          }
        }
      }

      return count;
    },
    orElse: () => 0,
  );
});

/// 오늘의 완료율을 제공하는 Provider
final todayCompletionRateProvider = Provider<double>((ref) {
  final todayRoutines = ref.watch(todayRoutinesProvider);
  final completedCount = ref.watch(todayCompletedCountProvider);

  if (todayRoutines.isEmpty) return 0.0;
  return completedCount / todayRoutines.length;
});

/// 선택된 루틴을 관리하는 Provider
final selectedRoutineProvider = StateProvider<Routine?>((ref) => null);

/// 루틴 추가/수정 모드를 관리하는 Provider
final routineFormModeProvider = StateProvider<FormMode>((ref) => FormMode.add);

/// 폼 모드 열거형
enum FormMode {
  add,
  edit,
}