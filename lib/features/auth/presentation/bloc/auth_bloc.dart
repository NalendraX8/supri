import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/session_storage.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Auth BLoC for managing authentication state.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final SessionStorage sessionStorage;

  AuthBloc({
    required this.repository,
    required this.sessionStorage,
  }) : super(const AuthInitial()) {
    on<AppStartedEvent>(_onAppStarted);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<SelectOutletEvent>(_onSelectOutlet);
  }

  Future<void> _onAppStarted(AppStartedEvent event, Emitter<AuthState> emit) async {
    final session = await sessionStorage.getSession();
    if (session.isLoggedIn && session.sessionId != null && session.sessionId!.isNotEmpty) {
      final auth = AuthEntity(
        userId: session.email,
        name: session.fullName,
        email: session.email,
        role: 'cashier',
        companyName: 'Zales POS',
        siteName: session.siteName,
        sessionId: session.sessionId,
        isLoggedIn: true,
      );
      emit(AuthAuthenticated(auth: auth, needsOutletSelection: false));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final auth = await repository.login(event.email, event.password);
      await sessionStorage.saveSession(SessionData(
        siteName: auth.siteName,
        sessionId: auth.sessionId,
        email: auth.email,
        fullName: auth.name,
        isLoggedIn: true,
      ));
      emit(AuthAuthenticated(auth: auth, needsOutletSelection: true));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await sessionStorage.clearSession();
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
    } else {
      emit(const AuthError('Cannot select outlet: not authenticated'));
    }
  }
}
