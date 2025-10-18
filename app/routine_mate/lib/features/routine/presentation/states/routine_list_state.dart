import '../../domain/entities/routine.dart';

/// 루틴 리스트 화면의 상태를 관리하는 클래스
class RoutineListState {
  /// 현재 표시되는 루틴 목록
  final List<Routine> routines;

  /// 로딩 상태
  final bool isLoading;

  /// 초기 로딩 상태 (첫 로드 시에만 true)
  final bool isInitialLoading;

  /// 에러 메시지
  final String? errorMessage;

  /// 현재 적용된 필터
  final FilterType filterType;

  /// 현재 적용된 정렬 방식
  final SortType sortType;

  /// 오늘 날짜의 완료 상태 맵 (routineId -> isCompleted)
  final Map<String, bool> todayCompletions;

  /// 각 루틴의 연속 달성 일수 (routineId -> streakDays)
  final Map<String, int> streaks;

  const RoutineListState({
    this.routines = const [],
    this.isLoading = false,
    this.isInitialLoading = true,
    this.errorMessage,
    this.filterType = FilterType.all,
    this.sortType = SortType.custom,
    this.todayCompletions = const {},
    this.streaks = const {},
  });

  /// copyWith 메서드
  RoutineListState copyWith({
    List<Routine>? routines,
    bool? isLoading,
    bool? isInitialLoading,
    String? errorMessage,
    FilterType? filterType,
    SortType? sortType,
    Map<String, bool>? todayCompletions,
    Map<String, int>? streaks,
  }) {
    return RoutineListState(
      routines: routines ?? this.routines,
      isLoading: isLoading ?? this.isLoading,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      filterType: filterType ?? this.filterType,
      sortType: sortType ?? this.sortType,
      todayCompletions: todayCompletions ?? this.todayCompletions,
      streaks: streaks ?? this.streaks,
    );
  }
}

/// 필터 타입 열거형
enum FilterType {
  all('전체'),
  today('오늘'),
  completed('완료'),
  incomplete('미완료'),
  active('활성'),
  archived('보관됨');

  final String label;
  const FilterType(this.label);
}

/// 정렬 타입 열거형
enum SortType {
  custom('사용자 정의'),
  name('이름순'),
  created('생성일순'),
  updated('수정일순'),
  completion('완료율순'),
  streak('연속 달성순'),
  color('색상순');

  final String label;
  const SortType(this.label);
}