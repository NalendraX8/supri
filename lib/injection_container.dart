import 'package:get_it/get_it.dart';

import 'features/example/data/datasources/example_local_datasource.dart';
import 'features/example/data/repositories/example_repository_impl.dart';
import 'features/example/domain/repositories/example_repository.dart';
import 'features/example/domain/usecases/get_example_by_id_usecase.dart';
import 'features/example/domain/usecases/get_examples_usecase.dart';
import 'features/example/presentation/bloc/example_bloc.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Initializes all dependencies.
Future<void> initDependencies() async {
  // BLoC
  sl.registerFactory(
    () => ExampleBloc(
      getExamplesUseCase: sl(),
      getExampleByIdUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetExamplesUseCase(sl()));
  sl.registerLazySingleton(() => GetExampleByIdUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ExampleRepository>(
    () => ExampleRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ExampleLocalDataSource>(
    () => ExampleLocalDataSourceImpl(),
  );
}
