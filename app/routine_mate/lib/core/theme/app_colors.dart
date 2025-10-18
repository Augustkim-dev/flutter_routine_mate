import 'package:flutter/material.dart';

/// 앱 색상 팔레트 정의
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryIndigo = Color(0xFF6366F1);
  static const Color primaryIndigoLight = Color(0xFF818CF8);
  static const Color primaryIndigoDark = Color(0xFF4F46E5);

  // Surface Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color surfaceVariantDark = Color(0xFF2A2A2A);

  // Text Colors
  static const Color onSurface = Color(0xFF1A1A1A);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);
  static const Color onSurfaceVariant = Color(0xFF666666);
  static const Color onSurfaceVariantDark = Color(0xFFB3B3B3);

  // Special Colors (배지용)
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);
  static const Color diamond = Color(0xFFB9F2FF);

  // Routine Colors (8개 색상)
  static const List<Color> routineColors = [
    Color(0xFF6366F1), // Indigo (Primary)
    Color(0xFF3B82F6), // Blue
    Color(0xFF10B981), // Green
    Color(0xFFFBBF24), // Yellow
    Color(0xFFF97316), // Orange
    Color(0xFFEF4444), // Red
    Color(0xFFEC4899), // Pink
    Color(0xFF8B5CF6), // Purple
  ];

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFDC2626);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Neutral Colors
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFE5E5E5);
  static const Color gray300 = Color(0xFFD4D4D4);
  static const Color gray400 = Color(0xFFA3A3A3);
  static const Color gray500 = Color(0xFF737373);
  static const Color gray600 = Color(0xFF525252);
  static const Color gray700 = Color(0xFF404040);
  static const Color gray800 = Color(0xFF262626);
  static const Color gray900 = Color(0xFF171717);

  // Background Colors
  static const Color background = Color(0xFFFAFAFB);
  static const Color backgroundDark = Color(0xFF121212);

  // 루틴 색상 이름 (한글)
  static const List<String> routineColorNames = [
    '인디고',
    '파랑',
    '초록',
    '노랑',
    '주황',
    '빨강',
    '분홍',
    '보라',
  ];

  /// 색상 인덱스로 루틴 색상 가져오기
  static Color getRoutineColor(int index) {
    if (index < 0 || index >= routineColors.length) {
      return routineColors[0];
    }
    return routineColors[index];
  }

  /// 색상 인덱스로 색상 이름 가져오기
  static String getRoutineColorName(int index) {
    if (index < 0 || index >= routineColorNames.length) {
      return routineColorNames[0];
    }
    return routineColorNames[index];
  }
}