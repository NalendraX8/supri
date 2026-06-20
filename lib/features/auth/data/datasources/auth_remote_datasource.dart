import '../../domain/entities/auth_entity.dart';

/// Remote data source for authentication.
/// Uses mock login for demo purposes.
/// In production, replace with real auth API.
class AuthRemoteDataSource {

  /// Mock login - accepts any email/password for demo.
  /// In production, replace with real auth API.
  Future<AuthEntity> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock validation - accept any non-empty credentials
    if (email.isNotEmpty && password.isNotEmpty) {
      return AuthEntity(
        userId: '1',
        email: email,
        name: 'Demo User',
        role: 'admin',
        isLoggedIn: true,
      );
    }
    throw Exception('Invalid credentials');
  }
}
