import 'package:get_it/get_it.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/sales/presentation/bloc/sales_bloc.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Initializes all dependencies.
Future<void> initDependencies() async {
  // BLoC
  sl.registerFactory(() => AuthBloc());
  sl.registerFactory(() => SalesBloc());
}
