// lib/core/di/injection.dart

import 'package:get_it/get_it.dart';
import 'package:optifila/repositories/business_repository.dart';
import 'package:optifila/repositories/ticket_repository.dart';

import '../../repositories/api_rest/TicketRepositoryImpl.dart';
import '../../repositories/api_rest/business_repository_imp.dart';
import '../network/rest/api_client.dart';
import '../../repositories/api_rest/auth_repository_impl.dart';
import '../../repositories/category_repository.dart';
import '../network/ws/stomp_service.dart';

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

  getIt.registerLazySingleton<BusinessRepositoryImpl>(
        () => BusinessRepositoryImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<TicketRepository>(
        () => TicketRepositoryImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<StompService>(
          () => StompService()
  );
}