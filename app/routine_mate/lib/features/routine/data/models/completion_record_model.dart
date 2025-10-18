import '../../domain/entities/completion_record.dart';
import '../../../../core/utils/constants.dart';

/// 완료 기록 데이터 모델 (데이터 레이어)
class CompletionRecordModel {
  final int? id;
  final String routineId;
  final String date;
  final int isCompleted;
  final String? completedAt;
  final String? note;
  final String createdAt;

  CompletionRecordModel({
    required this.routineId,
    required this.date,
    required this.isCompleted,
    required this.createdAt,
    this.id,
    this.completedAt,
    this.note,
  });

  /// Map으로부터 모델을 생성합니다 (데이터베이스에서 읽기)
  factory CompletionRecordModel.fromMap(Map<String, dynamic> map) {
    return CompletionRecordModel(
      id: map[AppConstants.columnId] as int?,
      routineId: map[AppConstants.columnRoutineId] as String,
      date: map[AppConstants.columnDate] as String,
      isCompleted: map[AppConstants.columnIsCompleted] as int,
      completedAt: map[AppConstants.columnCompletedAt] as String?,
      note: map[AppConstants.columnNote] as String?,
      createdAt: map[AppConstants.columnCreatedAt] as String,
    );
  }

  /// 모델을 Map으로 변환합니다 (데이터베이스에 저장)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      AppConstants.columnRoutineId: routineId,
      AppConstants.columnDate: date,
      AppConstants.columnIsCompleted: isCompleted,
      AppConstants.columnCreatedAt: createdAt,
    };

    if (id != null) {
      map[AppConstants.columnId] = id;
    }
    if (completedAt != null) {
      map[AppConstants.columnCompletedAt] = completedAt;
    }
    if (note != null) {
      map[AppConstants.columnNote] = note;
    }

    return map;
  }

  /// 도메인 엔티티로 변환합니다
  CompletionRecord toEntity() {
    return CompletionRecord(
      id: id,
      routineId: routineId,
      date: DateTime.parse(date),
      isCompleted: isCompleted == 1,
      createdAt: DateTime.parse(createdAt),
      completedAt: completedAt != null ? DateTime.parse(completedAt!) : null,
      note: note,
    );
  }

  /// 도메인 엔티티로부터 모델을 생성합니다
  static CompletionRecordModel fromEntity(CompletionRecord entity) {
    return CompletionRecordModel(
      id: entity.id,
      routineId: entity.routineId,
      date: entity.dateString,
      isCompleted: entity.isCompleted ? 1 : 0,
      createdAt: entity.createdAt.toIso8601String(),
      completedAt: entity.completedAt?.toIso8601String(),
      note: entity.note,
    );
  }

  /// 복사본을 생성합니다
  CompletionRecordModel copyWith({
    int? id,
    String? routineId,
    String? date,
    int? isCompleted,
    String? completedAt,
    String? note,
    String? createdAt,
  }) {
    return CompletionRecordModel(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      note: note ?? this.note,
    );
  }
}