import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/auth_entity.dart';

/// Remote data source for authentication querying Zales REST API.
class AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSource({required this.client});

  /// Real two-step login sequence.
  Future<AuthEntity> login(String email, String password) async {
    // Step 1: Resolve site details from global endpoint
    final step1Uri = Uri.parse('https://login.fintoapp.com/api/method/login');
    final step1Response = await client.post(
      step1Uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    if (step1Response.statusCode != 200) {
      throw Exception('Gagal menghubungi server otentikasi pusat (Status: ${step1Response.statusCode})');
    }

    final step1Data = json.decode(step1Response.body);
    final message = step1Data['message'];
    if (message == null || message['site_name'] == null) {
      throw Exception('Email tidak terdaftar atau tidak memiliki akses site.');
    }

    final String siteName = message['site_name'] as String;
    final String companyName = (message['company_name'] as String?) ?? 'Zales POS';

    // Step 2: Authenticate to tenant site
    final step2Uri = Uri.parse('$siteName/api/method/login');
    final step2Response = await client.post(
      step2Uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'usr': email, 'pwd': password}),
    );

    if (step2Response.statusCode != 200) {
      final errorData = json.decode(step2Response.body);
      final errorMsg = errorData['message'] ?? 'Password salah atau akun dinonaktifkan.';
      throw Exception(errorMsg);
    }

    final step2Data = json.decode(step2Response.body);
    final String fullName = step2Data['full_name'] ?? 'Kasir Zales';

    // Parse session cookie (sid) from Set-Cookie header
    String? sessionId;
    final rawCookie = step2Response.headers['set-cookie'] ?? step2Response.headers['Set-Cookie'];
    if (rawCookie != null) {
      final match = RegExp(r'sid=([^;]+)').firstMatch(rawCookie);
      if (match != null) {
        sessionId = match.group(1);
      }
    }

    return AuthEntity(
      userId: email,
      name: fullName,
      email: email,
      role: 'cashier',
      companyName: companyName,
      siteName: siteName,
      sessionId: sessionId,
      isLoggedIn: true,
    );
  }
}
