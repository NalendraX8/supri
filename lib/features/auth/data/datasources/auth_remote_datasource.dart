import '../../../../core/network/api_remote_datasource.dart';
import '../../domain/entities/auth_entity.dart';

/// Remote data source for authentication.
class AuthRemoteDataSource {
  final ApiRemoteDataSource api;

  AuthRemoteDataSource({required this.api});

  Future<AuthEntity> login(String email, String password) async {
    final response = await api.login(email, password);
    return AuthEntity(
      userId: response.id,
      email: response.email,
      name: response.name,
      role: response.role,
      isLoggedIn: true,
    );
  }
}
