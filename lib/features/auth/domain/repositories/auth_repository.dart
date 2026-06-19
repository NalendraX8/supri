import '../entities/auth_entity.dart';

/// Repository interface for auth operations.
abstract class AuthRepository {
  /// Login with email and password.
  Future<AuthEntity> login(String email, String password);
}
