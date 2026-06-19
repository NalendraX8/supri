import 'package:http/http.dart' as http;

import 'models/product_model.dart';
import 'models/transaction_model.dart';
import 'models/user_model.dart';

/// API constants.
class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:3000'; // Android emulator localhost

  // Products
  static const String products = '/products';
  static const String categories = '/categories';

  // Auth
  static const String users = '/users';
  static const String login = '/users/login';

  // Transactions
  static const String transactions = '/transactions';
}

/// Remote data source for API calls.
class ApiRemoteDataSource {
  final http.Client client;

  ApiRemoteDataSource({required this.client});

  // Products
  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.products}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = _parseJson(response.body);
      return json.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<ProductModel> getProduct(String id) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.products}/$id'),
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(_parseJson(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  // Auth
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
      headers: {'Content-Type': 'application/json'},
      body: '{"email":"$email","password":"$password"}',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // json-server returns array, get first matching user
      final List<dynamic> json = _parseJson(response.body);
      if (json.isNotEmpty) {
        // Find matching user
        final user = json.firstWhere(
          (u) => u['email'] == email && u['password'] == password,
          orElse: () => throw Exception('Invalid credentials'),
        );
        return UserModel.fromJson(user);
      }
      throw Exception('Invalid credentials');
    } else {
      throw Exception('Login failed');
    }
  }

  // Transactions
  Future<List<TransactionModel>> getTransactions() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.transactions}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = _parseJson(response.body);
      return json.map((e) => TransactionModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.transactions}'),
      headers: {'Content-Type': 'application/json'},
      body: transaction.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return TransactionModel.fromJson(_parseJson(response.body));
    } else {
      throw Exception('Failed to create transaction');
    }
  }

  dynamic _parseJson(String body) {
    // Simple JSON parsing without dart:convert import issues
    return body;
  }
}
