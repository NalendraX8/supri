import 'package:equatable/equatable.dart';

/// Domain entity representing an example item.
/// This is a pure Dart class with no dependencies on external packages.
class ExampleEntity extends Equatable {
  final String id;
  final String title;
  final String description;

  const ExampleEntity({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [id, title, description];
}
