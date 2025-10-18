/// 앱 전체에서 사용되는 상수 정의
class AppConstants {
  // Database
  static const String databaseName = 'routine_mate.db';
  static const int databaseVersion = 1;

  // Table Names
  static const String tableRoutines = 'routines';
  static const String tableCompletionRecords = 'completion_records';
  static const String tableAppSettings = 'app_settings';
  static const String tableAnalyticsData = 'analytics_data';

  // Routine Table Columns
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnIconIndex = 'icon_index';
  static const String columnColorIndex = 'color_index';
  static const String columnScheduleType = 'schedule_type';
  static const String columnCustomDays = 'custom_days';
  static const String columnSortOrder = 'sort_order';
  static const String columnReminderTime = 'reminder_time';
  static const String columnIsReminderEnabled = 'is_reminder_enabled';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
  static const String columnDeletedAt = 'deleted_at';

  // Completion Record Table Columns
  static const String columnRoutineId = 'routine_id';
  static const String columnDate = 'date';
  static const String columnIsCompleted = 'is_completed';
  static const String columnCompletedAt = 'completed_at';
  static const String columnNote = 'note';

  // App Settings Keys
  static const String settingThemeMode = 'theme_mode';
  static const String settingNotificationEnabled = 'notification_enabled';
  static const String settingDefaultReminderTime = 'default_reminder_time';
  static const String settingLanguage = 'language';
  static const String settingFirstLaunch = 'first_launch';

  // Limits
  static const int maxRoutineName = 20;
  static const int maxRoutines = 30;
  static const int maxNote = 200;

  // Schedule Types
  static const String scheduleDaily = 'daily';
  static const String scheduleWeekday = 'weekday';
  static const String scheduleWeekend = 'weekend';
  static const String scheduleCustom = 'custom';

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';

  // Default Values
  static const int defaultIconIndex = 0;
  static const int defaultColorIndex = 0;
  static const String defaultReminderTime = '09:00';

  // Colors (Material Design 3)
  static const List<int> colorOptions = [
    0xFF6366F1, // Indigo (Primary)
    0xFFEF4444, // Red
    0xFFF59E0B, // Amber
    0xFF10B981, // Emerald
    0xFF3B82F6, // Blue
    0xFF8B5CF6, // Violet
    0xFFEC4899, // Pink
    0xFF6B7280, // Gray
  ];

  // Icons
  static const List<String> iconOptions = [
    'check_circle',
    'fitness_center',
    'book',
    'water_drop',
    'bedtime',
    'directions_run',
    'self_improvement',
    'restaurant',
    'code',
    'brush',
    'music_note',
    'language',
    'work',
    'school',
    'favorite',
    'home',
    'star',
    'emoji_events',
    'psychology',
    'eco',
    'pets',
    'local_cafe',
    'flight_takeoff',
    'camera',
    'videogame_asset',
    'sports_esports',
    'piano',
    'palette',
    'science',
    'engineering',
  ];

  // Analytics Events
  static const String eventRoutineCreated = 'routine_created';
  static const String eventRoutineDeleted = 'routine_deleted';
  static const String eventRoutineCompleted = 'routine_completed';
  static const String eventRoutineUncompleted = 'routine_uncompleted';
  static const String eventStreakAchieved = 'streak_achieved';
  static const String eventWidgetAdded = 'widget_added';
  static const String eventReminderSet = 'reminder_set';
}