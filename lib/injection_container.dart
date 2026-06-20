import 'package:get_it/get_it.dart';

import 'core/network/mock_product_datasource.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/sales/data/datasources/product_remote_datasource.dart';
import 'features/sales/data/repositories/product_repository_impl.dart';
import 'features/sales/domain/repositories/product_repository.dart';
import 'features/sales/presentation/bloc/sales_bloc.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Initializes all dependencies.
Future<void> initDependencies() async {
  // Mock data sources
  sl.registerLazySingleton(() => MockProductDataSource());

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(),
  );
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(mockDataSource: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  // BLoC
  sl.registerFactory(() => AuthBloc(repository: sl()));
  sl.registerFactory(() => SalesBloc(repository: sl()));
}
