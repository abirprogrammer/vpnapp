import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vpn_config_model.dart';
import '../services/vpn_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  final bool isEmbedded;

  const SettingsScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnService>(
      builder: (context, vpnService, child) {
        final config = vpnService.config;

        return Scaffold(
          appBar: AppBar(
            title: const Text('VPN Settings'),
            automaticallyImplyLeading: !isEmbedded,
          ),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              _buildSectionHeader('CONNECTION PROTOCOL'),
              const SizedBox(height: 10),

              // Protocol Selector
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.surfaceLight),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    children: VpnProtocol.values.map((protocol) {
                      final isSelected = config.protocol == protocol;
                      return ListTile(
                        onTap: () => vpnService.setProtocol(protocol),
                        leading: Icon(
                          isSelected
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: isSelected
                              ? AppTheme.primaryCyan
                              : AppTheme.textMuted,
                        ),
                        title: Text(
                          protocol.displayName,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          isSelected ? 'Active Protocol' : 'Tap to switch',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 28),
              _buildSectionHeader('SECURITY & PRIVACY'),
              const SizedBox(height: 10),

              // Kill Switch
              _buildSwitchTile(
                title: 'Kill Switch',
                subtitle:
                    'Block internet access if VPN connection drops unexpectedly',
                icon: Icons.shield_moon_rounded,
                value: config.killSwitchEnabled,
                onChanged: (val) => vpnService.toggleKillSwitch(val),
              ),
              const SizedBox(height: 12),

              // Split Tunneling
              _buildSwitchTile(
                title: 'Split Tunneling',
                subtitle: 'Select specific apps to bypass VPN encryption',
                icon: Icons.call_split_rounded,
                value: config.splitTunnelingEnabled,
                onChanged: (val) => vpnService.toggleSplitTunneling(val),
              ),
              const SizedBox(height: 12),

              // Auto Connect
              _buildSwitchTile(
                title: 'Auto-Connect on Wi-Fi',
                subtitle:
                    'Automatically secure device when connecting to untrusted networks',
                icon: Icons.wifi_protected_setup_rounded,
                value: config.autoConnectWifi,
                onChanged: (val) => vpnService.toggleAutoConnectWifi(val),
              ),
              const SizedBox(height: 12),

              // DNS Leak Protection
              _buildSwitchTile(
                title: 'DNS Leak Protection',
                subtitle: 'Route all DNS queries through private secure DNS',
                icon: Icons.dns_rounded,
                value: config.dnsLeakProtection,
                onChanged: (val) => vpnService.toggleDnsLeakProtection(val),
              ),

              const SizedBox(height: 28),
              _buildSectionHeader('ABOUT POWERVPN'),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.surfaceLight),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.info_outline_rounded,
                            color: AppTheme.primaryCyan),
                        title: const Text('App Version',
                            style: TextStyle(color: AppTheme.textPrimary)),
                        trailing: const Text('v1.0.0 (Build 1)',
                            style: TextStyle(color: AppTheme.textSecondary)),
                      ),
                      const Divider(height: 1, color: AppTheme.surfaceLight),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip_outlined,
                            color: AppTheme.primaryCyan),
                        title: const Text('Privacy Policy',
                            style: TextStyle(color: AppTheme.textPrimary)),
                        trailing: const Icon(Icons.chevron_right_rounded,
                            color: AppTheme.textMuted),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Strict No-Logs Policy: PowerVPN does not store any browsing logs.'),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, color: AppTheme.surfaceLight),
                      ListTile(
                        leading: const Icon(Icons.verified_user_outlined,
                            color: AppTheme.primaryCyan),
                        title: const Text('Encryption Standard',
                            style: TextStyle(color: AppTheme.textPrimary)),
                        trailing: const Text('AES-256-GCM',
                            style: TextStyle(color: AppTheme.connectedEmerald)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.primaryCyan,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceLight),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: SwitchListTile(
          activeThumbColor: AppTheme.primaryCyan,
          value: value,
          onChanged: onChanged,
          secondary: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryCyan.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryCyan, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
