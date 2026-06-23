import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/outlet_selection_page.dart';
import 'features/sales/presentation/bloc/sales_bloc.dart';
import 'features/sales/presentation/pages/sales_page.dart';
import 'features/settings/presentation/pages/rekap_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/transaction/presentation/pages/history_page.dart';
import 'features/transaction/presentation/pages/kas_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const SupriApp());
}

class SupriApp extends StatelessWidget {
  const SupriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<SalesBloc>()),
      ],
      child: MaterialApp(
        title: 'Supri POS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AppNavigator(),
      ),
    );
  }
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthUnauthenticated || state is AuthInitial) {
          return const LoginPage();
        }

        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthError) {
          return LoginPage(errorMessage: state.message);
        }

        if (state is AuthAuthenticated) {
          if (state.needsOutletSelection) {
            return const OutletSelectionPage();
          }
          return const MainNavigator();
        }

        return const LoginPage();
      },
    );
  }
}

/// Main navigation wrapper using drawer only (no bottom nav bar)
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => MainNavigatorState();
}

class MainNavigatorState extends State<MainNavigator> {
  int _currentPage = 0; // 0=Sales, 1=Kas, 2=History, 3=Rekap, 4=Settings

  void navigateTo(int index) {
    setState(() => _currentPage = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentPage,
        children: [
          _buildPage(0, const SalesPage(
            onNavigateToHistory: null,
            onNavigateToKas: null,
            onNavigateToRekap: null,
            onNavigateToSettings: null,
            onLogout: null,
          )),
          _buildPage(1, KasPage(
            onNavigateToSales: null,
            onNavigateToHistory: null,
            onNavigateToRekap: null,
            onNavigateToSettings: null,
            onLogout: null,
          )),
          _buildPage(2, HistoryPage(
            onNavigateToSales: null,
            onNavigateToKas: null,
            onNavigateToRekap: null,
            onNavigateToSettings: null,
            onLogout: null,
          )),
          _buildPage(3, RekapPage(
            onNavigateToSales: null,
            onNavigateToHistory: null,
            onNavigateToKas: null,
            onNavigateToSettings: null,
            onLogout: null,
          )),
          _buildPage(4, SettingsPage(
            onNavigateToSales: null,
            onNavigateToHistory: null,
            onNavigateToKas: null,
            onNavigateToRekap: null,
            onLogout: null,
          )),
        ],
      ),
      // No bottom navigation bar - using drawer only like Zales
    );
  }

  Widget _buildPage(int index, Widget page) {
    return _PageWrapper(
      pageIndex: index,
      currentPage: _currentPage,
      onNavigate: navigateTo,
      child: page,
    );
  }
}

/// Wrapper to inject navigation callbacks into pages
class _PageWrapper extends StatefulWidget {
  final int pageIndex;
  final int currentPage;
  final Function(int) onNavigate;
  final Widget child;

  const _PageWrapper({
    required this.pageIndex,
    required this.currentPage,
    required this.onNavigate,
    required this.child,
  });

  @override
  State<_PageWrapper> createState() => _PageWrapperState();
}

class _PageWrapperState extends State<_PageWrapper> {
  @override
  Widget build(BuildContext context) {
    return _NavigationProvider(
      onNavigateToSales: () => widget.onNavigate(0),
      onNavigateToKas: () => widget.onNavigate(1),
      onNavigateToHistory: () => widget.onNavigate(2),
      onNavigateToRekap: () => widget.onNavigate(3),
      onNavigateToSettings: () => widget.onNavigate(4),
      onLogout: () => _logout(context),
      child: widget.child,
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(const LogoutEvent());
            },
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );
  }
}

/// Provides navigation callbacks to child widgets
class _NavigationProvider extends InheritedWidget {
  final VoidCallback onNavigateToSales;
  final VoidCallback onNavigateToKas;
  final VoidCallback onNavigateToHistory;
  final VoidCallback onNavigateToRekap;
  final VoidCallback onNavigateToSettings;
  final VoidCallback onLogout;

  const _NavigationProvider({
    required this.onNavigateToSales,
    required this.onNavigateToKas,
    required this.onNavigateToHistory,
    required this.onNavigateToRekap,
    required this.onNavigateToSettings,
    required this.onLogout,
    required super.child,
  });

  static _NavigationProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<_NavigationProvider>();
    if (provider == null) {
      throw FlutterError('No _NavigationProvider found in context');
    }
    return provider;
  }

  @override
  bool updateShouldNotify(_NavigationProvider oldWidget) => false;
}

/// Extension to easily access navigation from any context
extension NavigationExtension on BuildContext {
  void navigateToSales() => _NavigationProvider.of(this).onNavigateToSales();
  void navigateToKas() => _NavigationProvider.of(this).onNavigateToKas();
  void navigateToHistory() => _NavigationProvider.of(this).onNavigateToHistory();
  void navigateToRekap() => _NavigationProvider.of(this).onNavigateToRekap();
  void navigateToSettings() => _NavigationProvider.of(this).onNavigateToSettings();
  void logout() => _NavigationProvider.of(this).onLogout();
}
