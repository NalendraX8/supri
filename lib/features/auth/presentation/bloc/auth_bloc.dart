import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/auth_entity.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Auth BLoC for managing authentication state.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<SelectOutletEvent>(_onSelectOutlet);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock successful login - user needs to select outlet next
    final auth = AuthEntity(
      userId: 'user_001',
      email: event.email,
      isLoggedIn: true,
      // Mock outlets for demo
    );

    emit(AuthAuthenticated(auth: auth, needsOutletSelection: true));
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(const AuthUnauthenticated());
  }

  void _onSelectOutlet(SelectOutletEvent event, Emitter<AuthState> emit) {
    if (state is AuthAuthenticated) {
      final currentAuth = (state as AuthAuthenticated).auth;
      final updatedAuth = currentAuth.copyWith(
        outletId: event.outletId,
        outletName: event.outletName,
      );
      emit(AuthAuthenticated(auth: updatedAuth, needsOutletSelection: false));
    }
  }
}
