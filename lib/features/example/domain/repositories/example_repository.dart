import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/example_entity.dart';

/// Abstract repository contract for example feature.
/// Defines the contract that the data layer must implement.
abstract class ExampleRepository {
  /// Gets all example items.
  Future<Either<Failure, List<ExampleEntity>>> getExamples();

  /// Gets a single example item by ID.
  Future<Either<Failure, ExampleEntity>> getExampleById(String id);
}
