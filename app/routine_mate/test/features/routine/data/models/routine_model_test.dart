import 'package:flutter_test/flutter_test.dart';
import 'package:routine_mate/features/routine/data/models/routine_model.dart';
import 'package:routine_mate/features/routine/domain/entities/routine.dart';
import 'package:routine_mate/features/routine/domain/entities/schedule_type.dart';
import 'package:routine_mate/core/utils/constants.dart';

void main() {
  group('RoutineModel', () {
    final tRoutineModel = RoutineModel(
      id: '123e4567-e89b-12d3-a456-426614174000',
      name: '아침 운동',
      iconIndex: 5,
      colorIndex: 2,
      scheduleType: 'daily',
      sortOrder: 0,
      isReminderEnabled: 1,
      createdAt: '2024-01-01T09:00:00',
      updatedAt: '2024-01-01T09:00:00',
      customDays: '[1,2,3,4,5]',
      reminderTime: '07:00',
    );

    final tMap = {
      AppConstants.columnId: '123e4567-e89b-12d3-a456-426614174000',
      AppConstants.columnName: '아침 운동',
      AppConstants.columnIconIndex: 5,
      AppConstants.columnColorIndex: 2,
      AppConstants.columnScheduleType: 'daily',
      AppConstants.columnCustomDays: '[1,2,3,4,5]',
      AppConstants.columnSortOrder: 0,
      AppConstants.columnReminderTime: '07:00',
      AppConstants.columnIsReminderEnabled: 1,
      AppConstants.columnCreatedAt: '2024-01-01T09:00:00',
      AppConstants.columnUpdatedAt: '2024-01-01T09:00:00',
      AppConstants.columnDeletedAt: null,
    };

    test('fromMap 메서드가 올바른 모델을 생성해야 함', () {
      // act
      final result = RoutineModel.fromMap(tMap);

      // assert
      expect(result.id, tRoutineModel.id);
      expect(result.name, tRoutineModel.name);
      expect(result.iconIndex, tRoutineModel.iconIndex);
      expect(result.colorIndex, tRoutineModel.colorIndex);
      expect(result.scheduleType, tRoutineModel.scheduleType);
      expect(result.customDays, tRoutineModel.customDays);
      expect(result.sortOrder, tRoutineModel.sortOrder);
      expect(result.reminderTime, tRoutineModel.reminderTime);
      expect(result.isReminderEnabled, tRoutineModel.isReminderEnabled);
      expect(result.createdAt, tRoutineModel.createdAt);
      expect(result.updatedAt, tRoutineModel.updatedAt);
      expect(result.deletedAt, tRoutineModel.deletedAt);
    });

    test('toMap 메서드가 올바른 Map을 반환해야 함', () {
      // act
      final result = tRoutineModel.toMap();

      // assert
      expect(result, tMap);
    });

    test('toEntity 메서드가 올바른 도메인 엔티티를 반환해야 함', () {
      // act
      final result = tRoutineModel.toEntity();

      // assert
      expect(result, isA<Routine>());
      expect(result.id, tRoutineModel.id);
      expect(result.name, tRoutineModel.name);
      expect(result.iconIndex, tRoutineModel.iconIndex);
      expect(result.colorIndex, tRoutineModel.colorIndex);
      expect(result.scheduleType, ScheduleType.daily);
      expect(result.customDays, [1, 2, 3, 4, 5]);
      expect(result.sortOrder, tRoutineModel.sortOrder);
      expect(result.reminderTime, tRoutineModel.reminderTime);
      expect(result.isReminderEnabled, true);
      expect(result.createdAt, DateTime.parse(tRoutineModel.createdAt));
      expect(result.updatedAt, DateTime.parse(tRoutineModel.updatedAt));
      expect(result.deletedAt, null);
    });

    test('fromEntity 메서드가 올바른 모델을 생성해야 함', () {
      // arrange
      final entity = Routine(
        id: '123e4567-e89b-12d3-a456-426614174000',
        name: '아침 운동',
        iconIndex: 5,
        colorIndex: 2,
        scheduleType: ScheduleType.custom,
        sortOrder: 0,
        isReminderEnabled: true,
        createdAt: DateTime.parse('2024-01-01T09:00:00'),
        updatedAt: DateTime.parse('2024-01-01T09:00:00'),
        customDays: const [1, 2, 3, 4, 5],
        reminderTime: '07:00',
      );

      // act
      final result = RoutineModel.fromEntity(entity);

      // assert
      expect(result.id, entity.id);
      expect(result.name, entity.name);
      expect(result.iconIndex, entity.iconIndex);
      expect(result.colorIndex, entity.colorIndex);
      expect(result.scheduleType, 'custom');
      expect(result.customDays, '[1,2,3,4,5]');
      expect(result.sortOrder, entity.sortOrder);
      expect(result.reminderTime, entity.reminderTime);
      expect(result.isReminderEnabled, 1);
    });

    test('copyWith 메서드가 올바르게 동작해야 함', () {
      // act
      final result = tRoutineModel.copyWith(
        name: '저녁 운동',
        colorIndex: 4,
      );

      // assert
      expect(result.name, '저녁 운동');
      expect(result.colorIndex, 4);
      expect(result.id, tRoutineModel.id);
      expect(result.iconIndex, tRoutineModel.iconIndex);
      expect(result.scheduleType, tRoutineModel.scheduleType);
    });
  });
}