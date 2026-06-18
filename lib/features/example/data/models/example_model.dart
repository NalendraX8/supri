import '../../domain/entities/example_entity.dart';

/// Data model for Example with JSON serialization.
class ExampleModel extends ExampleEntity {
  const ExampleModel({
    required super.id,
    required super.title,
    required super.description,
  });

  /// Creates an ExampleModel from JSON map.
  factory ExampleModel.fromJson(Map<String, dynamic> json) {
    return ExampleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  /// Converts ExampleModel to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  /// Creates an ExampleModel from an ExampleEntity.
  factory ExampleModel.fromEntity(ExampleEntity entity) {
    return ExampleModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
    );
  }
}
