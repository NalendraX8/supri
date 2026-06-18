import 'package:equatable/equatable.dart';

import '../../domain/entities/example_entity.dart';

/// Base class for all Example BLoC states.
abstract class ExampleState extends Equatable {
  const ExampleState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action.
class ExampleInitial extends ExampleState {
  const ExampleInitial();
}

/// State while loading examples.
class ExampleLoading extends ExampleState {
  const ExampleLoading();
}

/// State when examples are loaded successfully.
class ExamplesLoaded extends ExampleState {
  final List<ExampleEntity> examples;

  const ExamplesLoaded(this.examples);

  @override
  List<Object?> get props => [examples];
}

/// State when a single example is loaded successfully.
class ExampleLoaded extends ExampleState {
  final ExampleEntity example;

  const ExampleLoaded(this.example);

  @override
  List<Object?> get props => [example];
}

/// State when an error occurs.
class ExampleError extends ExampleState {
  final String message;

  const ExampleError(this.message);

  @override
  List<Object?> get props => [message];
}
