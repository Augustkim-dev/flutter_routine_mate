import 'package:flutter/material.dart';

/// 앱 아이콘 정의 (30개 프리셋)
class AppIcons {
  AppIcons._();

  // 루틴 아이콘 목록 (30개)
  static const List<IconData> routineIcons = [
    // 건강 & 운동 (6개)
    Icons.directions_run,
    Icons.fitness_center,
    Icons.self_improvement,
    Icons.favorite,
    Icons.directions_bike,
    Icons.pool,

    // 학습 & 업무 (6개)
    Icons.menu_book,
    Icons.laptop_mac,
    Icons.edit,
    Icons.work_outline,
    Icons.school,
    Icons.lightbulb_outline,

    // 일상 & 습관 (6개)
    Icons.coffee,
    Icons.local_drink,
    Icons.bedtime,
    Icons.alarm,
    Icons.restaurant,
    Icons.home,

    // 취미 & 여가 (6개)
    Icons.music_note,
    Icons.palette,
    Icons.photo_camera,
    Icons.sports_esports,
    Icons.movie,
    Icons.park,

    // 자기관리 (6개)
    Icons.face,
    Icons.spa,
    Icons.shopping_cart,
    Icons.cleaning_services,
    Icons.brush,
    Icons.checkroom,
  ];

  // 아이콘 카테고리 이름 (한글)
  static const List<String> iconCategories = [
    '건강 & 운동',
    '학습 & 업무',
    '일상 & 습관',
    '취미 & 여가',
    '자기관리',
  ];

  // 아이콘 이름 (한글)
  static const List<String> iconNames = [
    // 건강 & 운동
    '달리기',
    '헬스',
    '요가',
    '건강',
    '자전거',
    '수영',

    // 학습 & 업무
    '독서',
    '코딩',
    '글쓰기',
    '업무',
    '공부',
    '아이디어',

    // 일상 & 습관
    '커피',
    '물마시기',
    '수면',
    '알람',
    '식사',
    '집',

    // 취미 & 여가
    '음악',
    '그림',
    '사진',
    '게임',
    '영화',
    '산책',

    // 자기관리
    '스킨케어',
    '명상',
    '쇼핑',
    '청소',
    '양치',
    '옷관리',
  ];

  // UI 아이콘
  static const IconData check = Icons.check;
  static const IconData checkCircle = Icons.check_circle;
  static const IconData add = Icons.add;
  static const IconData edit = Icons.edit;
  static const IconData delete = Icons.delete;
  static const IconData settings = Icons.settings;
  static const IconData more = Icons.more_vert;
  static const IconData close = Icons.close;
  static const IconData back = Icons.arrow_back_ios_new;
  static const IconData forward = Icons.arrow_forward_ios;
  static const IconData expand = Icons.expand_more;
  static const IconData collapse = Icons.expand_less;
  static const IconData calendar = Icons.calendar_today;
  static const IconData time = Icons.access_time;
  static const IconData notification = Icons.notifications_outlined;
  static const IconData notificationActive = Icons.notifications;
  static const IconData star = Icons.star;
  static const IconData starOutline = Icons.star_outline;
  static const IconData filter = Icons.filter_list;
  static const IconData sort = Icons.sort;
  static const IconData drag = Icons.drag_handle;

  /// 아이콘 인덱스로 아이콘 가져오기
  static IconData getRoutineIcon(int index) {
    if (index < 0 || index >= routineIcons.length) {
      return routineIcons[0];
    }
    return routineIcons[index];
  }

  /// getIcon 별칭 (호환성)
  static IconData getIcon(int index) => getRoutineIcon(index);

  /// 아이콘 인덱스로 아이콘 이름 가져오기
  static String getRoutineIconName(int index) {
    if (index < 0 || index >= iconNames.length) {
      return iconNames[0];
    }
    return iconNames[index];
  }

  /// 카테고리별 아이콘 인덱스 범위 가져오기
  static List<int> getIconIndexesByCategory(int categoryIndex) {
    if (categoryIndex < 0 || categoryIndex >= iconCategories.length) {
      return List.generate(6, (i) => i);
    }

    int startIndex = categoryIndex * 6;
    return List.generate(6, (i) => startIndex + i);
  }

  /// 아이콘 인덱스로 카테고리 인덱스 가져오기
  static int getCategoryByIconIndex(int iconIndex) {
    if (iconIndex < 0 || iconIndex >= routineIcons.length) {
      return 0;
    }
    return iconIndex ~/ 6;
  }
}