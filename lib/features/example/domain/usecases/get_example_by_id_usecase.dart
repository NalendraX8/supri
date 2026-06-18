import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/example_entity.dart';
import '../repositories/example_repository.dart';

/// Use case to get a single example by ID.
class GetExampleByIdUseCase implements UseCase<ExampleEntity, String> {
  final ExampleRepository repository;

  GetExampleByIdUseCase(this.repository);

  @override
  Future<Either<Failure, ExampleEntity>> call(String id) {
    return repository.getExampleById(id);
  }
}
