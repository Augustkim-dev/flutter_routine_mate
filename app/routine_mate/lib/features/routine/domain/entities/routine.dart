import 'package:flutter/foundation.dart';
import 'schedule_type.dart';

/// 루틴을 나타내는 도메인 엔티티
@immutable
class Routine {
  final String id;
  final String name;
  final int iconIndex;
  final int colorIndex;
  final ScheduleType scheduleType;
  final List<int>? customDays;
  final int sortOrder;
  final String? reminderTime;
  final bool isReminderEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Routine({
    required this.id,
    required this.name,
    required this.iconIndex,
    required this.colorIndex,
    required this.scheduleType,
    required this.sortOrder,
    required this.isReminderEnabled,
    required this.createdAt,
    required this.updatedAt,
    this.customDays,
    this.reminderTime,
    this.deletedAt,
  });

  /// 루틴이 삭제되었는지 확인합니다
  bool get isDeleted => deletedAt != null;

  /// 루틴이 활성 상태인지 확인합니다
  bool get isActive => !isDeleted;

  /// 특정 날짜에 루틴이 활성화되는지 확인합니다
  bool isActiveOnDate(DateTime date) {
    if (isDeleted) return false;
    return scheduleType.isActiveOnDate(date, customDays);
  }

  /// 스케줄 설명을 가져옵니다
  String get scheduleDescription {
    return scheduleType.getDescription(customDays);
  }

  /// 복사본을 생성합니다
  Routine copyWith({
    String? id,
    String? name,
    int? iconIndex,
    int? colorIndex,
    ScheduleType? scheduleType,
    List<int>? customDays,
    int? sortOrder,
    String? reminderTime,
    bool? isReminderEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      iconIndex: iconIndex ?? this.iconIndex,
      colorIndex: colorIndex ?? this.colorIndex,
      scheduleType: scheduleType ?? this.scheduleType,
      customDays: customDays ?? this.customDays,
      sortOrder: sortOrder ?? this.sortOrder,
      reminderTime: reminderTime ?? this.reminderTime,
      isReminderEnabled: isReminderEnabled ?? this.isReminderEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Routine &&
        other.id == id &&
        other.name == name &&
        other.iconIndex == iconIndex &&
        other.colorIndex == colorIndex &&
        other.scheduleType == scheduleType &&
        listEquals(other.customDays, customDays) &&
        other.sortOrder == sortOrder &&
        other.reminderTime == reminderTime &&
        other.isReminderEnabled == isReminderEnabled &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      iconIndex,
      colorIndex,
      scheduleType,
      customDays,
      sortOrder,
      reminderTime,
      isReminderEnabled,
      createdAt,
      updatedAt,
      deletedAt,
    );
  }

  @override
  String toString() {
    return 'Routine(id: $id, name: $name, scheduleType: ${scheduleType.value}, isDeleted: $isDeleted)';
  }
}