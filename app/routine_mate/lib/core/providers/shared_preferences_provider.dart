import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences 인스턴스를 제공하는 Provider
/// 앱 설정 및 사용자 프리퍼런스 저장에 사용
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// 테마 모드 설정을 관리하는 Provider
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

/// 앱 테마 모드 열거형
enum ThemeMode {
  light,
  dark,
  system,
}

/// 언어 설정을 관리하는 Provider
final languageProvider = StateProvider<String>((ref) {
  return 'ko'; // 기본값: 한국어
});

/// 알림 설정을 관리하는 Provider
final notificationEnabledProvider = StateProvider<bool>((ref) {
  return true; // 기본값: 알림 활성화
});

/// 첫 실행 여부를 확인하는 Provider
final isFirstLaunchProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return prefs.getBool('is_first_launch') ?? true;
});

/// 첫 실행 플래그를 업데이트하는 함수
Future<void> setFirstLaunchComplete(WidgetRef ref) async {
  final prefs = await ref.read(sharedPreferencesProvider.future);
  await prefs.setBool('is_first_launch', false);
}