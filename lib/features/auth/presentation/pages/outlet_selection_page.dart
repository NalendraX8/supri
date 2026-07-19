import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Outlet selection page after login.
class OutletSelectionPage extends StatefulWidget {
  const OutletSelectionPage({super.key});

  @override
  State<OutletSelectionPage> createState() => _OutletSelectionPageState();
}

class _OutletSelectionPageState extends State<OutletSelectionPage> {
  late final Future<List<String>> _outletsFuture;

  @override
  void initState() {
    super.initState();
    _outletsFuture = _fetchPOSProfiles();
  }

  Future<List<String>> _fetchPOSProfiles() async {
    final response = await sl<ApiClient>().get('/api/resource/POS Profile?fields=["name"]');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> profiles = data['data'] ?? [];
      if (profiles.isNotEmpty) {
        return profiles.map((p) => p['name'] as String).toList();
      }
    }
    throw Exception('Failed to load POS Profiles (Status: ${response.statusCode})');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pilih Outlet'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return Center(
              child: SpinKitFadingCircle(
                color: AppColors.primary,
                size: 50.0,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Mengoperasikan banyak outlet hanya 1 aplikasi',
                  style: TextStyle(
                    color: AppColors.grey600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Outlet List from API
                Expanded(
                  child: FutureBuilder<List<String>>(
                    future: _outletsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SpinKitFadingCircle(
                            color: AppColors.primary,
                            size: 40.0,
                          ),
                        );
                      }
                      
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                                const SizedBox(height: 16),
                                Text(
                                  'Gagal memuat outlet: ${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: AppColors.error),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final outlets = snapshot.data ?? [];
                      if (outlets.isEmpty) {
                        return const Center(
                          child: Text('Tidak ada outlet yang tersedia'),
                        );
                      }

                      return ListView.builder(
                        itemCount: outlets.length,
                        itemBuilder: (context, index) {
                          final name = outlets[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _OutletCard(
                              name: name,
                              onTap: () => _selectOutlet(context, 'outlet_$index', name),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _selectOutlet(BuildContext context, String outletId, String outletName) {
    context.read<AuthBloc>().add(
          SelectOutletEvent(outletId: outletId, outletName: outletName),
        );
  }
}

class _OutletCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const _OutletCard({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.store_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.grey400,
          ),
        ],
      ),
    );
  }
}
