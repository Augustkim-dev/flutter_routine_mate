import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../utils/constants.dart';

/// SQLite 데이터베이스 관리를 위한 헬퍼 클래스
class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._internal();

  DatabaseHelper._internal();

  /// 데이터베이스 인스턴스를 가져옵니다
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// 데이터베이스를 초기화합니다
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  /// 데이터베이스 설정
  Future<void> _onConfigure(Database db) async {
    // 외래 키 제약 조건 활성화
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// 데이터베이스 테이블 생성
  Future<void> _onCreate(Database db, int version) async {
    // 루틴 테이블 생성
    await db.execute('''
      CREATE TABLE ${AppConstants.tableRoutines} (
        ${AppConstants.columnId} TEXT PRIMARY KEY,
        ${AppConstants.columnName} TEXT NOT NULL,
        ${AppConstants.columnIconIndex} INTEGER NOT NULL DEFAULT 0,
        ${AppConstants.columnColorIndex} INTEGER NOT NULL DEFAULT 0,
        ${AppConstants.columnScheduleType} TEXT NOT NULL DEFAULT '${AppConstants.scheduleDaily}',
        ${AppConstants.columnCustomDays} TEXT,
        ${AppConstants.columnSortOrder} INTEGER NOT NULL DEFAULT 0,
        ${AppConstants.columnReminderTime} TEXT,
        ${AppConstants.columnIsReminderEnabled} INTEGER NOT NULL DEFAULT 0,
        ${AppConstants.columnCreatedAt} TEXT NOT NULL,
        ${AppConstants.columnUpdatedAt} TEXT NOT NULL,
        ${AppConstants.columnDeletedAt} TEXT
      )
    ''');

    // 완료 기록 테이블 생성
    await db.execute('''
      CREATE TABLE ${AppConstants.tableCompletionRecords} (
        ${AppConstants.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.columnRoutineId} TEXT NOT NULL,
        ${AppConstants.columnDate} TEXT NOT NULL,
        ${AppConstants.columnIsCompleted} INTEGER NOT NULL DEFAULT 1,
        ${AppConstants.columnCompletedAt} TEXT,
        ${AppConstants.columnNote} TEXT,
        ${AppConstants.columnCreatedAt} TEXT NOT NULL,
        FOREIGN KEY (${AppConstants.columnRoutineId}) REFERENCES ${AppConstants.tableRoutines}(${AppConstants.columnId}) ON DELETE CASCADE,
        UNIQUE(${AppConstants.columnRoutineId}, ${AppConstants.columnDate})
      )
    ''');

    // 앱 설정 테이블 생성
    await db.execute('''
      CREATE TABLE ${AppConstants.tableAppSettings} (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        ${AppConstants.columnUpdatedAt} TEXT NOT NULL
      )
    ''');

    // 분석 데이터 테이블 생성
    await db.execute('''
      CREATE TABLE ${AppConstants.tableAnalyticsData} (
        ${AppConstants.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        event_name TEXT NOT NULL,
        event_data TEXT,
        ${AppConstants.columnCreatedAt} TEXT NOT NULL
      )
    ''');

    // 인덱스 생성
    await _createIndexes(db);

    // 기본 설정 값 삽입
    await _insertDefaultSettings(db);
  }

  /// 인덱스 생성
  Future<void> _createIndexes(Database db) async {
    // 루틴 테이블 인덱스
    await db.execute('''
      CREATE INDEX idx_routines_deleted_at
      ON ${AppConstants.tableRoutines}(${AppConstants.columnDeletedAt})
    ''');

    await db.execute('''
      CREATE INDEX idx_routines_sort_order
      ON ${AppConstants.tableRoutines}(${AppConstants.columnSortOrder})
    ''');

    // 완료 기록 테이블 인덱스
    await db.execute('''
      CREATE INDEX idx_completion_records_routine_id
      ON ${AppConstants.tableCompletionRecords}(${AppConstants.columnRoutineId})
    ''');

    await db.execute('''
      CREATE INDEX idx_completion_records_date
      ON ${AppConstants.tableCompletionRecords}(${AppConstants.columnDate})
    ''');

    await db.execute('''
      CREATE INDEX idx_completion_records_routine_date
      ON ${AppConstants.tableCompletionRecords}(${AppConstants.columnRoutineId}, ${AppConstants.columnDate})
    ''');

    // 분석 데이터 테이블 인덱스
    await db.execute('''
      CREATE INDEX idx_analytics_data_event_name
      ON ${AppConstants.tableAnalyticsData}(event_name)
    ''');

    await db.execute('''
      CREATE INDEX idx_analytics_data_created_at
      ON ${AppConstants.tableAnalyticsData}(${AppConstants.columnCreatedAt})
    ''');
  }

  /// 기본 설정 값 삽입
  Future<void> _insertDefaultSettings(Database db) async {
    final now = DateTime.now().toIso8601String();
    final settings = {
      AppConstants.settingThemeMode: 'system',
      AppConstants.settingNotificationEnabled: 'true',
      AppConstants.settingDefaultReminderTime: AppConstants.defaultReminderTime,
      AppConstants.settingLanguage: 'ko',
      AppConstants.settingFirstLaunch: 'true',
    };

    for (final entry in settings.entries) {
      await db.insert(
        AppConstants.tableAppSettings,
        {
          'key': entry.key,
          'value': entry.value,
          AppConstants.columnUpdatedAt: now,
        },
      );
    }
  }

  /// 데이터베이스 업그레이드
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 향후 스키마 변경 시 마이그레이션 로직 구현
    // 예시:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE routines ADD COLUMN new_column TEXT');
    // }
  }

  /// 데이터베이스 닫기
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// 트랜잭션 실행
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await database;
    return await db.transaction(action);
  }

  /// 데이터베이스 삭제 (테스트 용도)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  /// Soft delete된 레코드 정리 (30일 이상 된 것)
  Future<int> cleanupDeletedRecords() async {
    final db = await database;
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

    return await db.delete(
      AppConstants.tableRoutines,
      where: '${AppConstants.columnDeletedAt} IS NOT NULL AND ${AppConstants.columnDeletedAt} < ?',
      whereArgs: [thirtyDaysAgo.toIso8601String()],
    );
  }

  /// 데이터베이스 통계 정보 가져오기
  Future<Map<String, dynamic>> getDatabaseStats() async {
    final db = await database;

    final routineCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.tableRoutines} WHERE ${AppConstants.columnDeletedAt} IS NULL'),
    );

    final completionCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.tableCompletionRecords}'),
    );

    final analyticsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.tableAnalyticsData}'),
    );

    return {
      'routines': routineCount ?? 0,
      'completions': completionCount ?? 0,
      'analytics': analyticsCount ?? 0,
    };
  }
}