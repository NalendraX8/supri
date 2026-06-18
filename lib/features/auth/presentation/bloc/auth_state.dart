import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_entity.dart';

/// Auth state definitions.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state during authentication.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state with user data.
class AuthAuthenticated extends AuthState {
  final AuthEntity auth;
  final bool needsOutletSelection;

  const AuthAuthenticated({required this.auth, this.needsOutletSelection = false});

  @override
  List<Object?> get props => [auth, needsOutletSelection];
}

/// Unauthenticated state.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error state.
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
