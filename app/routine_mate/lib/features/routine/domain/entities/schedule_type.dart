/// 루틴 스케줄 타입을 나타내는 열거형
enum ScheduleType {
  daily('daily', '매일'),
  weekday('weekday', '평일'),
  weekend('weekend', '주말'),
  custom('custom', '사용자 지정');

  final String value;
  final String displayName;

  const ScheduleType(this.value, this.displayName);

  /// 문자열로부터 ScheduleType을 생성합니다
  static ScheduleType fromString(String value) {
    return ScheduleType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ScheduleType.daily,
    );
  }

  /// 스케줄에 따라 해당 날짜에 루틴이 활성화되는지 확인합니다
  bool isActiveOnDate(DateTime date, List<int>? customDays) {
    switch (this) {
      case ScheduleType.daily:
        return true;
      case ScheduleType.weekday:
        return date.weekday >= DateTime.monday && date.weekday <= DateTime.friday;
      case ScheduleType.weekend:
        return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
      case ScheduleType.custom:
        return customDays?.contains(date.weekday) ?? false;
    }
  }

  /// 스케줄 타입에 대한 설명을 반환합니다
  String getDescription(List<int>? customDays) {
    switch (this) {
      case ScheduleType.daily:
        return '매일';
      case ScheduleType.weekday:
        return '월-금';
      case ScheduleType.weekend:
        return '토-일';
      case ScheduleType.custom:
        if (customDays == null || customDays.isEmpty) {
          return '사용자 지정';
        }
        final dayNames = customDays.map((day) => _getDayName(day)).join(', ');
        return dayNames;
    }
  }

  /// 요일 번호를 요일 이름으로 변환합니다
  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return '월';
      case DateTime.tuesday:
        return '화';
      case DateTime.wednesday:
        return '수';
      case DateTime.thursday:
        return '목';
      case DateTime.friday:
        return '금';
      case DateTime.saturday:
        return '토';
      case DateTime.sunday:
        return '일';
      default:
        return '';
    }
  }
}