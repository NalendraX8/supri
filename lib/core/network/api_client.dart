import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/settings_storage.dart';
import '../storage/session_storage.dart';

/// Central HTTP API Client for all Zales REST services, dynamically resolving URL and Cookie from SessionStorage.
class ApiClient {
  final http.Client httpClient;
  final SettingsStorage settingsStorage;
  final SessionStorage sessionStorage;

  ApiClient({
    required this.httpClient,
    required this.settingsStorage,
    required this.sessionStorage,
  });

  Future<String> _getBaseUrl() async {
    final session = await sessionStorage.getSession();
    if (session.siteName != null && session.siteName!.isNotEmpty) {
      return session.siteName!;
    }
    final mode = await settingsStorage.getMode();
    return mode == 'demo' ? 'https://demo.fintoapp.com' : 'https://login.fintoapp.com';
  }

  Future<Map<String, String>> _getHeaders() async {
    final session = await sessionStorage.getSession();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (session.sessionId != null && session.sessionId!.isNotEmpty) {
      headers['Cookie'] = 'sid=${session.sessionId}';
    } else {
      headers['Authorization'] = 'token 12345abcde:67890fghij';
    }
    return headers;
  }

  /// Perform HTTP GET request.
  Future<http.Response> get(String path) async {
    final baseUrl = await _getBaseUrl();
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _getHeaders();
    return await httpClient.get(uri, headers: headers);
  }

  /// Perform HTTP POST request.
  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final baseUrl = await _getBaseUrl();
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _getHeaders();
    return await httpClient.post(
      uri,
      headers: headers,
      body: json.encode(body),
    );
  }
}
