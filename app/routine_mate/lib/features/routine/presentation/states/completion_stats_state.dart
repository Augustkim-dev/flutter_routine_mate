/// 완료 통계 상태를 관리하는 클래스
class CompletionStatsState {
  /// 오늘 총 루틴 개수
  final int totalTodayRoutines;

  /// 오늘 완료한 루틴 개수
  final int completedTodayRoutines;

  /// 오늘 완료율 (0.0 ~ 1.0)
  final double todayCompletionRate;

  /// 이번 주 완료율 (0.0 ~ 1.0)
  final double weeklyCompletionRate;

  /// 이번 달 완료율 (0.0 ~ 1.0)
  final double monthlyCompletionRate;

  /// 전체 평균 완료율 (0.0 ~ 1.0)
  final double overallCompletionRate;

  /// 최장 연속 달성 일수
  final int longestStreak;

  /// 현재 연속 달성 일수
  final int currentStreak;

  /// 총 완료한 루틴 횟수
  final int totalCompletions;

  /// 각 루틴별 완료율 (routineId -> completion rate)
  final Map<String, double> routineCompletionRates;

  /// 각 루틴별 연속 달성 일수 (routineId -> streak days)
  final Map<String, int> routineStreaks;

  /// 통계 로딩 중 여부
  final bool isLoading;

  /// 에러 메시지
  final String? errorMessage;

  const CompletionStatsState({
    this.totalTodayRoutines = 0,
    this.completedTodayRoutines = 0,
    this.todayCompletionRate = 0.0,
    this.weeklyCompletionRate = 0.0,
    this.monthlyCompletionRate = 0.0,
    this.overallCompletionRate = 0.0,
    this.longestStreak = 0,
    this.currentStreak = 0,
    this.totalCompletions = 0,
    this.routineCompletionRates = const {},
    this.routineStreaks = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  /// copyWith 메서드
  CompletionStatsState copyWith({
    int? totalTodayRoutines,
    int? completedTodayRoutines,
    double? todayCompletionRate,
    double? weeklyCompletionRate,
    double? monthlyCompletionRate,
    double? overallCompletionRate,
    int? longestStreak,
    int? currentStreak,
    int? totalCompletions,
    Map<String, double>? routineCompletionRates,
    Map<String, int>? routineStreaks,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CompletionStatsState(
      totalTodayRoutines: totalTodayRoutines ?? this.totalTodayRoutines,
      completedTodayRoutines: completedTodayRoutines ?? this.completedTodayRoutines,
      todayCompletionRate: todayCompletionRate ?? this.todayCompletionRate,
      weeklyCompletionRate: weeklyCompletionRate ?? this.weeklyCompletionRate,
      monthlyCompletionRate: monthlyCompletionRate ?? this.monthlyCompletionRate,
      overallCompletionRate: overallCompletionRate ?? this.overallCompletionRate,
      longestStreak: longestStreak ?? this.longestStreak,
      currentStreak: currentStreak ?? this.currentStreak,
      totalCompletions: totalCompletions ?? this.totalCompletions,
      routineCompletionRates: routineCompletionRates ?? this.routineCompletionRates,
      routineStreaks: routineStreaks ?? this.routineStreaks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// 오늘 완료율을 퍼센트로 표시
  String get todayCompletionPercentage =>
      '${(todayCompletionRate * 100).toStringAsFixed(0)}%';

  /// 이번 주 완료율을 퍼센트로 표시
  String get weeklyCompletionPercentage =>
      '${(weeklyCompletionRate * 100).toStringAsFixed(0)}%';

  /// 이번 달 완료율을 퍼센트로 표시
  String get monthlyCompletionPercentage =>
      '${(monthlyCompletionRate * 100).toStringAsFixed(0)}%';

  /// 진행률 메시지
  String get progressMessage {
    if (totalTodayRoutines == 0) {
      return '오늘 할 루틴이 없어요';
    } else if (completedTodayRoutines == totalTodayRoutines) {
      return '🎉 오늘의 모든 루틴을 완료했어요!';
    } else if (completedTodayRoutines == 0) {
      return '오늘의 루틴을 시작해보세요';
    } else {
      return '$completedTodayRoutines / $totalTodayRoutines 완료';
    }
  }

  /// 연속 달성 메시지
  String get streakMessage {
    if (currentStreak == 0) {
      return '연속 달성을 시작해보세요';
    } else if (currentStreak == 1) {
      return '🔥 1일 연속 달성!';
    } else if (currentStreak < 7) {
      return '🔥 $currentStreak일 연속 달성!';
    } else if (currentStreak < 30) {
      return '🔥 $currentStreak일 연속! 대단해요!';
    } else {
      return '🏆 $currentStreak일 연속! 놀라워요!';
    }
  }
}