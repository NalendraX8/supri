import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/example_entity.dart';
import '../../domain/repositories/example_repository.dart';
import '../datasources/example_local_datasource.dart';

/// Implementation of ExampleRepository.
class ExampleRepositoryImpl implements ExampleRepository {
  final ExampleLocalDataSource localDataSource;

  ExampleRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ExampleEntity>>> getExamples() async {
    try {
      final examples = await localDataSource.getExamples();
      return Right(examples);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExampleEntity>> getExampleById(String id) async {
    try {
      final example = await localDataSource.getExampleById(id);
      return Right(example);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
