import 'package:uuid/uuid.dart';

/// UUID 생성을 위한 유틸리티 클래스
class UuidGenerator {
  static const _uuid = Uuid();

  /// 새로운 UUID v4를 생성합니다
  static String generate() {
    return _uuid.v4();
  }

  /// 타임스탬프 기반 UUID v1을 생성합니다
  static String generateTimeBased() {
    return _uuid.v1();
  }

  /// 주어진 문자열이 유효한 UUID인지 검증합니다
  static bool isValid(String id) {
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    return uuidRegex.hasMatch(id);
  }
}