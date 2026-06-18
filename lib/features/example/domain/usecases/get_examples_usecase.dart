import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/example_entity.dart';
import '../repositories/example_repository.dart';

/// Use case to get all examples.
class GetExamplesUseCase implements UseCase<List<ExampleEntity>, NoParams> {
  final ExampleRepository repository;

  GetExamplesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ExampleEntity>>> call(NoParams params) {
    return repository.getExamples();
  }
}
