import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';

/// 데이터베이스 인스턴스를 제공하는 Provider
/// 앱 전체에서 하나의 데이터베이스 인스턴스를 공유
final databaseProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

/// 데이터베이스 초기화 상태를 관리하는 FutureProvider
/// 앱 시작 시 데이터베이스가 준비될 때까지 대기
final databaseInitializerProvider = FutureProvider<void>((ref) async {
  final database = ref.watch(databaseProvider);
  await database.database; // 데이터베이스 초기화 대기
});