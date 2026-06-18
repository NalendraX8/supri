import 'package:equatable/equatable.dart';

/// Auth entity representing user authentication state.
class AuthEntity extends Equatable {
  final String? userId;
  final String? email;
  final String? outletId;
  final String? outletName;
  final String? companyName;
  final bool isLoggedIn;

  const AuthEntity({
    this.userId,
    this.email,
    this.outletId,
    this.outletName,
    this.companyName,
    this.isLoggedIn = false,
  });

  AuthEntity copyWith({
    String? userId,
    String? email,
    String? outletId,
    String? outletName,
    String? companyName,
    bool? isLoggedIn,
  }) {
    return AuthEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      outletId: outletId ?? this.outletId,
      outletName: outletName ?? this.outletName,
      companyName: companyName ?? this.companyName,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  @override
  List<Object?> get props => [userId, email, outletId, outletName, companyName, isLoggedIn];
}
