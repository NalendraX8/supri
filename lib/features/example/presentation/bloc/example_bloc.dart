import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_example_by_id_usecase.dart';
import '../../domain/usecases/get_examples_usecase.dart';
import 'example_event.dart';
import 'example_state.dart';

/// BLoC for managing example feature state.
class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  final GetExamplesUseCase getExamplesUseCase;
  final GetExampleByIdUseCase getExampleByIdUseCase;

  ExampleBloc({
    required this.getExamplesUseCase,
    required this.getExampleByIdUseCase,
  }) : super(const ExampleInitial()) {
    on<GetExamplesEvent>(_onGetExamples);
    on<GetExampleByIdEvent>(_onGetExampleById);
  }

  Future<void> _onGetExamples(
    GetExamplesEvent event,
    Emitter<ExampleState> emit,
  ) async {
    emit(const ExampleLoading());

    final result = await getExamplesUseCase(const NoParams());

    result.fold(
      (failure) => emit(ExampleError(failure.message)),
      (examples) => emit(ExamplesLoaded(examples)),
    );
  }

  Future<void> _onGetExampleById(
    GetExampleByIdEvent event,
    Emitter<ExampleState> emit,
  ) async {
    emit(const ExampleLoading());

    final result = await getExampleByIdUseCase(event.id);

    result.fold(
      (failure) => emit(ExampleError(failure.message)),
      (example) => emit(ExampleLoaded(example)),
    );
  }
}
