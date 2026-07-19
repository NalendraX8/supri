import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/settings_storage.dart';

/// Central HTTP API Client for all Zales REST services, dynamically resolving URL by active mode.
class ApiClient {
  final http.Client httpClient;
  final SettingsStorage settingsStorage;

  ApiClient({required this.httpClient, required this.settingsStorage});

  Future<String> _getBaseUrl() async {
    final mode = await settingsStorage.getMode();
    return mode == 'demo' ? 'https://demo.fintoapp.com' : 'https://login.fintoapp.com';
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'token 12345abcde:67890fghij', // Standard mock integration token from documentation
    };
  }

  /// Perform HTTP GET request.
  Future<http.Response> get(String path) async {
    final baseUrl = await _getBaseUrl();
    final uri = Uri.parse('$baseUrl$path');
    return await httpClient.get(uri, headers: _getHeaders());
  }

  /// Perform HTTP POST request.
  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final baseUrl = await _getBaseUrl();
    final uri = Uri.parse('$baseUrl$path');
    return await httpClient.post(
      uri,
      headers: _getHeaders(),
      body: json.encode(body),
    );
  }
}
