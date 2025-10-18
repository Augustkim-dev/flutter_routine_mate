import '../../domain/entities/schedule_type.dart';

/// 루틴 추가/수정 폼의 상태를 관리하는 클래스
class RoutineFormState {
  /// 루틴 이름
  final String name;

  /// 선택된 아이콘 인덱스
  final int iconIndex;

  /// 선택된 색상 인덱스
  final int colorIndex;

  /// 선택된 스케줄 타입
  final ScheduleType scheduleType;

  /// 사용자 정의 요일 (0: 일요일, 6: 토요일)
  final List<int> customDays;

  /// 알림 활성화 여부
  final bool isReminderEnabled;

  /// 알림 시간 (HH:mm 형식)
  final String? reminderTime;

  /// 폼 유효성 검사 통과 여부
  final bool isValid;

  /// 제출 중 상태
  final bool isSubmitting;

  /// 에러 메시지
  final String? errorMessage;

  /// 수정 모드인지 여부
  final bool isEditMode;

  /// 수정 중인 루틴 ID (수정 모드일 때만 사용)
  final String? editingRoutineId;

  const RoutineFormState({
    this.name = '',
    this.iconIndex = 0,
    this.colorIndex = 0,
    this.scheduleType = ScheduleType.daily,
    this.customDays = const [],
    this.isReminderEnabled = false,
    this.reminderTime,
    this.isValid = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.isEditMode = false,
    this.editingRoutineId,
  });

  /// copyWith 메서드
  RoutineFormState copyWith({
    String? name,
    int? iconIndex,
    int? colorIndex,
    ScheduleType? scheduleType,
    List<int>? customDays,
    bool? isReminderEnabled,
    String? reminderTime,
    bool? isValid,
    bool? isSubmitting,
    String? errorMessage,
    bool? isEditMode,
    String? editingRoutineId,
  }) {
    return RoutineFormState(
      name: name ?? this.name,
      iconIndex: iconIndex ?? this.iconIndex,
      colorIndex: colorIndex ?? this.colorIndex,
      scheduleType: scheduleType ?? this.scheduleType,
      customDays: customDays ?? this.customDays,
      isReminderEnabled: isReminderEnabled ?? this.isReminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      isValid: isValid ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      isEditMode: isEditMode ?? this.isEditMode,
      editingRoutineId: editingRoutineId ?? this.editingRoutineId,
    );
  }

  /// 폼이 제출 가능한 상태인지 확인
  bool get canSubmit => isValid && !isSubmitting && name.trim().isNotEmpty;

  /// 선택된 요일을 문자열로 변환
  String get scheduleDescription {
    switch (scheduleType) {
      case ScheduleType.daily:
        return '매일';
      case ScheduleType.weekday:
        return '평일';
      case ScheduleType.weekend:
        return '주말';
      case ScheduleType.custom:
        if (customDays.isEmpty) return '사용자 정의';
        final dayNames = ['일', '월', '화', '수', '목', '금', '토'];
        final selectedDays = customDays.map((d) => dayNames[d]).join(', ');
        return selectedDays;
    }
  }
}