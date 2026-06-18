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
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthUnauthenticated) {
          return const LoginPage();
        }

        if (state is AuthAuthenticated) {
          if (state.needsOutletSelection) {
            return const OutletSelectionPage();
          }
          return MainNavigator(initialIndex: 0);
        }

        return const LoginPage();
      },
    );
  }
}

class MainNavigator extends StatefulWidget {
  final int initialIndex;

  const MainNavigator({super.key, this.initialIndex = 0});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  late int _currentIndex;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    3,
    (_) => GlobalKey<NavigatorState>(),
  );

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildNavigator(0, _SalesWrapper()),
          _buildNavigator(1, HistoryPage()),
          _buildNavigator(2, _SettingsWrapper()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildNavigator(int index, Widget child) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (_) => child);
      },
    );
  }
}

// Wrappers to handle navigation callbacks
class _SalesWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SalesPage(
      onNavigateToHistory: () => _navigateTo(context, 1),
      onNavigateToKas: () => _showKasPage(context),
      onNavigateToRekap: () => _showRekapPage(context),
      onNavigateToSettings: () => _navigateTo(context, 2),
      onLogout: () => _logout(context),
    );
  }
}

class _SettingsWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      onNavigateToSales: () => _navigateTo(context, 0),
      onNavigateToHistory: () => _navigateTo(context, 1),
      onNavigateToKas: () => _showKasPage(context),
      onNavigateToRekap: () => _showRekapPage(context),
      onLogout: () => _logout(context),
    );
  }
}

void _navigateTo(BuildContext context, int index) {
  final mainState = context.findAncestorStateOfType<_MainNavigatorState>();
  mainState?._onTabTapped(index);
}

void _showKasPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const KasPage()),
  );
}

void _showRekapPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const RekapPage()),
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
