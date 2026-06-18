import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// Base class for all use cases.
/// [Type] is the return type, [Params] is the input parameters type.
abstract class UseCase<T, Params> {
  /// Executes the use case with given [params].
  /// Returns [Either] a [Failure] or [T].
  Future<Either<Failure, T>> call(Params params);
}

/// Use this class when no parameters are needed.
class NoParams {
  const NoParams();
}
