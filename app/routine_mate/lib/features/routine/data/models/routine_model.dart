import 'dart:convert';
import '../../domain/entities/routine.dart';
import '../../domain/entities/schedule_type.dart';
import '../../../../core/utils/constants.dart';

/// 루틴 데이터 모델 (데이터 레이어)
class RoutineModel {
  final String id;
  final String name;
  final int iconIndex;
  final int colorIndex;
  final String scheduleType;
  final String? customDays;
  final int sortOrder;
  final String? reminderTime;
  final int isReminderEnabled;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  RoutineModel({
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

  /// Map으로부터 모델을 생성합니다 (데이터베이스에서 읽기)
  factory RoutineModel.fromMap(Map<String, dynamic> map) {
    return RoutineModel(
      id: map[AppConstants.columnId] as String,
      name: map[AppConstants.columnName] as String,
      iconIndex: map[AppConstants.columnIconIndex] as int,
      colorIndex: map[AppConstants.columnColorIndex] as int,
      scheduleType: map[AppConstants.columnScheduleType] as String,
      customDays: map[AppConstants.columnCustomDays] as String?,
      sortOrder: map[AppConstants.columnSortOrder] as int,
      reminderTime: map[AppConstants.columnReminderTime] as String?,
      isReminderEnabled: map[AppConstants.columnIsReminderEnabled] as int,
      createdAt: map[AppConstants.columnCreatedAt] as String,
      updatedAt: map[AppConstants.columnUpdatedAt] as String,
      deletedAt: map[AppConstants.columnDeletedAt] as String?,
    );
  }

  /// 모델을 Map으로 변환합니다 (데이터베이스에 저장)
  Map<String, dynamic> toMap() {
    return {
      AppConstants.columnId: id,
      AppConstants.columnName: name,
      AppConstants.columnIconIndex: iconIndex,
      AppConstants.columnColorIndex: colorIndex,
      AppConstants.columnScheduleType: scheduleType,
      AppConstants.columnCustomDays: customDays,
      AppConstants.columnSortOrder: sortOrder,
      AppConstants.columnReminderTime: reminderTime,
      AppConstants.columnIsReminderEnabled: isReminderEnabled,
      AppConstants.columnCreatedAt: createdAt,
      AppConstants.columnUpdatedAt: updatedAt,
      AppConstants.columnDeletedAt: deletedAt,
    };
  }

  /// 도메인 엔티티로 변환합니다
  Routine toEntity() {
    List<int>? customDaysList;
    if (customDays != null && customDays!.isNotEmpty) {
      customDaysList = json.decode(customDays!).cast<int>();
    }

    return Routine(
      id: id,
      name: name,
      iconIndex: iconIndex,
      colorIndex: colorIndex,
      scheduleType: ScheduleType.fromString(scheduleType),
      sortOrder: sortOrder,
      isReminderEnabled: isReminderEnabled == 1,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      customDays: customDaysList,
      reminderTime: reminderTime,
      deletedAt: deletedAt != null ? DateTime.parse(deletedAt!) : null,
    );
  }

  /// 도메인 엔티티로부터 모델을 생성합니다
  static RoutineModel fromEntity(Routine entity) {
    String? customDaysJson;
    if (entity.customDays != null && entity.customDays!.isNotEmpty) {
      customDaysJson = json.encode(entity.customDays);
    }

    return RoutineModel(
      id: entity.id,
      name: entity.name,
      iconIndex: entity.iconIndex,
      colorIndex: entity.colorIndex,
      scheduleType: entity.scheduleType.value,
      sortOrder: entity.sortOrder,
      isReminderEnabled: entity.isReminderEnabled ? 1 : 0,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      customDays: customDaysJson,
      reminderTime: entity.reminderTime,
      deletedAt: entity.deletedAt?.toIso8601String(),
    );
  }

  /// 복사본을 생성합니다
  RoutineModel copyWith({
    String? id,
    String? name,
    int? iconIndex,
    int? colorIndex,
    String? scheduleType,
    String? customDays,
    int? sortOrder,
    String? reminderTime,
    int? isReminderEnabled,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    return RoutineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconIndex: iconIndex ?? this.iconIndex,
      colorIndex: colorIndex ?? this.colorIndex,
      scheduleType: scheduleType ?? this.scheduleType,
      sortOrder: sortOrder ?? this.sortOrder,
      isReminderEnabled: isReminderEnabled ?? this.isReminderEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      customDays: customDays ?? this.customDays,
      reminderTime: reminderTime ?? this.reminderTime,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}