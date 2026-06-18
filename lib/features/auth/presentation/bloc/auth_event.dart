import 'package:equatable/equatable.dart';

/// Auth event definitions.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to attempt login.
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event to logout.
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

/// Event to select outlet.
class SelectOutletEvent extends AuthEvent {
  final String outletId;
  final String outletName;

  const SelectOutletEvent({required this.outletId, required this.outletName});

  @override
  List<Object?> get props => [outletId, outletName];
}
