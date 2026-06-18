import 'package:equatable/equatable.dart';

/// Base class for all Example BLoC events.
abstract class ExampleEvent extends Equatable {
  const ExampleEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all examples.
class GetExamplesEvent extends ExampleEvent {
  const GetExamplesEvent();
}

/// Event to load a single example by ID.
class GetExampleByIdEvent extends ExampleEvent {
  final String id;

  const GetExampleByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}
