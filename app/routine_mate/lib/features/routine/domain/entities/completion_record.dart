import 'package:flutter/foundation.dart';

/// 루틴 완료 기록을 나타내는 도메인 엔티티
@immutable
class CompletionRecord {
  final int? id;
  final String routineId;
  final DateTime date;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? note;
  final DateTime createdAt;

  const CompletionRecord({
    required this.routineId,
    required this.date,
    required this.isCompleted,
    required this.createdAt,
    this.id,
    this.completedAt,
    this.note,
  });

  /// 날짜를 문자열로 변환합니다 (YYYY-MM-DD)
  String get dateString {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// 완료 시간을 포맷팅합니다
  String? get formattedCompletedAt {
    if (completedAt == null) return null;
    final hour = completedAt!.hour.toString().padLeft(2, '0');
    final minute = completedAt!.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// 복사본을 생성합니다
  CompletionRecord copyWith({
    int? id,
    String? routineId,
    DateTime? date,
    bool? isCompleted,
    DateTime? completedAt,
    String? note,
    DateTime? createdAt,
  }) {
    return CompletionRecord(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompletionRecord &&
        other.id == id &&
        other.routineId == routineId &&
        other.date == date &&
        other.isCompleted == isCompleted &&
        other.completedAt == completedAt &&
        other.note == note &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      routineId,
      date,
      isCompleted,
      completedAt,
      note,
      createdAt,
    );
  }

  @override
  String toString() {
    return 'CompletionRecord(id: $id, routineId: $routineId, date: $dateString, isCompleted: $isCompleted)';
  }
}