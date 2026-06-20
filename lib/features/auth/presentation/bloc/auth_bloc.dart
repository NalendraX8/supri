import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Auth BLoC for managing authentication state.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  // Static outlets (can be fetched from API)
  static const List<Map<String, String>> outlets = [
    {'id': '1', 'name': 'Toko Utama'},
    {'id': '2', 'name': 'Cabang Selatan'},
    {'id': '3', 'name': 'Cabang Timur'},
  ];

  AuthBloc({required this.repository}) : super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<SelectOutletEvent>(_onSelectOutlet);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final auth = await repository.login(event.email, event.password);
      emit(AuthAuthenticated(auth: auth, needsOutletSelection: true));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) {
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
