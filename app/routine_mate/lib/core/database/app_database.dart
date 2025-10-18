import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_helper.dart';

/// 데이터베이스 Provider
final databaseProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

/// 데이터베이스 초기화 Provider
final databaseInitializerProvider = FutureProvider<void>((ref) async {
  final dbHelper = ref.watch(databaseProvider);
  await dbHelper.database; // 데이터베이스 초기화
});

/// 앱 데이터베이스 관리 클래스
class AppDatabase {
  final DatabaseHelper _dbHelper;

  AppDatabase(this._dbHelper);

  /// 데이터베이스 초기화
  Future<void> initialize() async {
    await _dbHelper.database;
  }

  /// 데이터베이스 닫기
  Future<void> close() async {
    await _dbHelper.close();
  }

  /// 데이터베이스 리셋 (개발/테스트 용도)
  Future<void> reset() async {
    await _dbHelper.deleteDatabase();
    await _dbHelper.database; // 재생성
  }

  /// Soft delete된 데이터 정리
  Future<int> cleanup() async {
    return await _dbHelper.cleanupDeletedRecords();
  }

  /// 데이터베이스 통계
  Future<Map<String, dynamic>> getStats() async {
    return await _dbHelper.getDatabaseStats();
  }
}