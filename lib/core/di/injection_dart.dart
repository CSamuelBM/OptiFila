// lib/core/di/injection.dart

import 'package:get_it/get_it.dart';

import '../network/rest/api_client.dart';
import '../../repositories/auth_repository_impl.dart';
import '../../repositories/category_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  /// CORE
  getIt.registerLazySingleton<ApiClient>(
        () => ApiClient(),
  );

  /// REPOSITORIES
  getIt.registerLazySingleton<AuthRepositoryImpl>(
        () => AuthRepositoryImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<CategoryRepository>(
        () => CategoryRepository(getIt<ApiClient>()),
  );
}