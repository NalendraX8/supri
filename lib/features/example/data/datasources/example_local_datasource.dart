import '../models/example_model.dart';

/// Abstract contract for local data source operations.
abstract class ExampleLocalDataSource {
  /// Gets all examples from local storage.
  Future<List<ExampleModel>> getExamples();

  /// Gets a single example by ID.
  Future<ExampleModel> getExampleById(String id);
}

/// Implementation of ExampleLocalDataSource using mock data.
class ExampleLocalDataSourceImpl implements ExampleLocalDataSource {
  // Mock data - replace with actual local storage (e.g., SharedPreferences, SQLite)
  final List<Map<String, dynamic>> _mockData = [
    {'id': '1', 'title': 'First Example', 'description': 'This is the first example item'},
    {'id': '2', 'title': 'Second Example', 'description': 'This is the second example item'},
    {'id': '3', 'title': 'Third Example', 'description': 'This is the third example item'},
  ];

  @override
  Future<List<ExampleModel>> getExamples() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockData.map((json) => ExampleModel.fromJson(json)).toList();
  }

  @override
  Future<ExampleModel> getExampleById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    final item = _mockData.firstWhere(
      (json) => json['id'] == id,
      orElse: () => throw Exception('Item not found'),
    );
    return ExampleModel.fromJson(item);
  }
}
