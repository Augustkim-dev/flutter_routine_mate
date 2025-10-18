import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/routine/data/datasources/routine_local_datasource.dart';
import '../../features/routine/data/repositories/routine_repository_impl.dart';
import '../../features/routine/domain/repositories/routine_repository.dart';
import 'database_provider.dart';

/// 루틴 로컬 데이터소스를 제공하는 Provider
final routineLocalDataSourceProvider = Provider<RoutineLocalDataSource>((ref) {
  final database = ref.watch(databaseProvider);
  return RoutineLocalDataSourceImpl(database);
});

/// 루틴 Repository를 제공하는 Provider
/// 데이터 접근 로직을 추상화하여 제공
final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  final localDataSource = ref.watch(routineLocalDataSourceProvider);
  return RoutineRepositoryImpl(localDataSource);
});