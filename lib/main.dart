import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
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

/// Main navigation wrapper with bottom NavigationBar
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
        children: const [
          SalesPage(
            onNavigateToHistory: null,
            onNavigateToKas: null,
            onNavigateToRekap: null,
            onNavigateToSettings: null,
            onLogout: null,
          ),
          KasPage(
            onNavigateToSales: null,
            onNavigateToHistory: null,
            onNavigateToRekap: null,
            onNavigateToSettings: null,
            onLogout: null,
          ),
          HistoryPage(
            onNavigateToSales: null,
            onNavigateToKas: null,
            onNavigateToRekap: null,
            onNavigateToSettings: null,
            onLogout: null,
          ),
          RekapPage(
            onNavigateToSales: null,
            onNavigateToHistory: null,
            onNavigateToKas: null,
            onNavigateToSettings: null,
            onLogout: null,
          ),
          SettingsPage(
            onNavigateToSales: null,
            onNavigateToHistory: null,
            onNavigateToKas: null,
            onNavigateToRekap: null,
            onLogout: null,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPage,
        onDestinationSelected: navigateTo,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Sales',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Kas',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Rekap',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
