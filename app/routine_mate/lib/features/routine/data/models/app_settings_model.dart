import '../../../../core/utils/constants.dart';

/// 앱 설정 데이터 모델
class AppSettingsModel {
  final String key;
  final String value;
  final String updatedAt;

  AppSettingsModel({
    required this.key,
    required this.value,
    required this.updatedAt,
  });

  /// Map으로부터 모델을 생성합니다
  factory AppSettingsModel.fromMap(Map<String, dynamic> map) {
    return AppSettingsModel(
      key: map['key'] as String,
      value: map['value'] as String,
      updatedAt: map[AppConstants.columnUpdatedAt] as String,
    );
  }

  /// 모델을 Map으로 변환합니다
  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
      AppConstants.columnUpdatedAt: updatedAt,
    };
  }

  /// 값을 특정 타입으로 변환합니다
  T getValue<T>() {
    if (T == bool) {
      return (value.toLowerCase() == 'true') as T;
    } else if (T == int) {
      return int.parse(value) as T;
    } else if (T == double) {
      return double.parse(value) as T;
    } else if (T == DateTime) {
      return DateTime.parse(value) as T;
    }
    return value as T;
  }

  /// 특정 타입의 값으로 모델을 생성합니다
  static AppSettingsModel fromValue<T>(String key, T value) {
    String stringValue;
    if (value is DateTime) {
      stringValue = value.toIso8601String();
    } else {
      stringValue = value.toString();
    }

    return AppSettingsModel(
      key: key,
      value: stringValue,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }

  /// 복사본을 생성합니다
  AppSettingsModel copyWith({
    String? key,
    String? value,
    String? updatedAt,
  }) {
    return AppSettingsModel(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}