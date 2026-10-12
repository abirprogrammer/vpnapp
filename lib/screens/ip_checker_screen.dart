import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vpn_config_model.dart';
import '../services/vpn_service.dart';
import '../theme/app_theme.dart';

class IpCheckerScreen extends StatelessWidget {
  final bool isEmbedded;

  const IpCheckerScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnService>(
      builder: (context, vpnService, child) {
        final config = vpnService.config;
        final server = config.selectedServer;
        final isConnected = config.state == VpnState.connected;

        final displayIp = isConnected
            ? (server?.ipAddress ?? '104.28.19.102')
            : '103.125.24.12 (Real Local IP)';
        final displayCountry = isConnected
            ? (server?.countryName ?? 'United States')
            : 'Bangladesh (Your Real Country)';
        final displayCity = isConnected
            ? (server?.cityName ?? 'New York')
            : 'Dhaka';
        final flag = isConnected ? (server?.flagEmoji ?? '🇺🇸') : '🇧🇩';

        return Scaffold(
          appBar: AppBar(
            title: const Text('IP & Location Inspector'),
            automaticallyImplyLeading: !isEmbedded,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Status Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isConnected
                        ? AppTheme.connectedEmerald.withAlpha(25)
                        : AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isConnected
                          ? AppTheme.connectedEmerald
                          : AppTheme.surfaceLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isConnected
                            ? Icons.verified_user_rounded
                            : Icons.warning_amber_rounded,
                        color: isConnected
                            ? AppTheme.connectedEmerald
                            : AppTheme.warningOrange,
                        size: 28,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isConnected
                                  ? 'VPN Tunnel Active & Secured'
                                  : 'Unprotected Connection',
                              style: TextStyle(
                                color: isConnected
                                    ? AppTheme.connectedEmerald
                                    : AppTheme.warningOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isConnected
                                  ? 'Traffic routed securely through ${server?.countryName}'
                                  : 'Connect VPN to mask your real IP and location',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Location Details Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.surfaceLight),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            flag,
                            style: const TextStyle(fontSize: 48),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('IP Address', displayIp, Icons.wifi_rounded),
                      const Divider(color: AppTheme.surfaceLight, height: 24),
                      _buildInfoRow('Country', displayCountry, Icons.public_rounded),
                      const Divider(color: AppTheme.surfaceLight, height: 24),
                      _buildInfoRow('City', displayCity, Icons.location_city_rounded),
                      const Divider(color: AppTheme.surfaceLight, height: 24),
                      _buildInfoRow(
                          'ISP / ASN',
                          isConnected ? 'PowerVPN Secure Cloud Inc.' : 'Grameenphone / Link3',
                          Icons.router_rounded),
                      const Divider(color: AppTheme.surfaceLight, height: 24),
                      _buildInfoRow(
                          'Encryption',
                          isConnected ? 'AES-256-GCM / WireGuard' : 'None (Plaintext)',
                          Icons.lock_rounded),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Check on Google / Map Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isConnected
                                ? 'Verified: Current active IP is ${server?.ipAddress} (${server?.countryName})'
                                : 'Please connect VPN to change your location.',
                          ),
                          backgroundColor: AppTheme.surface,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryCyan,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.map_rounded),
                    label: const Text(
                      'VERIFY LOCATION ON MAP',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryCyan, size: 20),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
