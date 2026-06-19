import 'package:equatable/equatable.dart';

/// Auth entity representing user authentication state.
class AuthEntity extends Equatable {
  final String? userId;
  final String? name;
  final String? email;
  final String? role;
  final String? outletId;
  final String? outletName;
  final String? companyName;
  final bool isLoggedIn;

  const AuthEntity({
    this.userId,
    this.name,
    this.email,
    this.role,
    this.outletId,
    this.outletName,
    this.companyName,
    this.isLoggedIn = false,
  });

  AuthEntity copyWith({
    String? userId,
    String? name,
    String? email,
    String? role,
    String? outletId,
    String? outletName,
    String? companyName,
    bool? isLoggedIn,
  }) {
    return AuthEntity(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      outletId: outletId ?? this.outletId,
      outletName: outletName ?? this.outletName,
      companyName: companyName ?? this.companyName,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  @override
  List<Object?> get props => [userId, name, email, role, outletId, outletName, companyName, isLoggedIn];
}
