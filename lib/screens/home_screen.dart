import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vpn_config_model.dart';
import '../services/vpn_service.dart';
import '../theme/app_theme.dart';
import '../widgets/power_vpn_logo.dart';
import '../widgets/stat_card.dart';
import '../widgets/vpn_power_button.dart';
import 'premium_screen.dart';
import 'server_list_screen.dart';
import 'speed_test_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onNavigateToLocations;
  final VoidCallback? onNavigateToSpeedTest;
  final VoidCallback? onNavigateToPremium;
  final VoidCallback? onNavigateToIpChecker;

  const HomeScreen({
    super.key,
    this.onNavigateToLocations,
    this.onNavigateToSpeedTest,
    this.onNavigateToPremium,
    this.onNavigateToIpChecker,
  });

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  String _formatSpeed(double speedKbps) {
    if (speedKbps >= 1024) {
      return "${(speedKbps / 1024).toStringAsFixed(1)} MB/s";
    }
    return "${speedKbps.toStringAsFixed(0)} KB/s";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnService>(
      builder: (context, vpnService, child) {
        final config = vpnService.config;
        final server = config.selectedServer;

        return Scaffold(
          appBar: AppBar(
            title: const PowerVpnLogo(size: 32),
            centerTitle: false,
            actions: [
              // Speed Test Button
              IconButton(
                icon: const Icon(Icons.speed_rounded, color: AppTheme.primaryCyan),
                tooltip: 'Speed Test',
                onPressed: () {
                  if (onNavigateToSpeedTest != null) {
                    onNavigateToSpeedTest!();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SpeedTestScreen(),
                      ),
                    );
                  }
                },
              ),
              // VIP Upgrade Button
              IconButton(
                icon: const Icon(Icons.workspace_premium_rounded,
                    color: AppTheme.goldPremium),
                tooltip: 'Go VIP',
                onPressed: () {
                  if (onNavigateToPremium != null) {
                    onNavigateToPremium!();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PremiumScreen(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // Selected Server Card Tile
                  InkWell(
                    onTap: () {
                      if (onNavigateToLocations != null) {
                        onNavigateToLocations!();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ServerListScreen(),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.surfaceLight),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            server?.flagEmoji ?? '🌐',
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  server?.countryName ?? 'Select Server',
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  server != null
                                      ? '${server.cityName} • Ping ${server.ping}ms'
                                      : 'Tap to pick location',
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryCyan.withAlpha(30),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'CHANGE',
                                  style: TextStyle(
                                    color: AppTheme.primaryCyan,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppTheme.primaryCyan,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Power Button Dial
                  VpnPowerButton(
                    state: config.state,
                    onTap: () => vpnService.toggleConnection(),
                  ),

                  const SizedBox(height: 36),

                  // Duration Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.surfaceLight),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          color: AppTheme.textSecondary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDuration(config.duration),
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Live Stats Grid (Download Speed & Upload Speed)
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'DOWNLOAD',
                          value: _formatSpeed(config.downloadSpeedKbps),
                          icon: Icons.arrow_downward_rounded,
                          iconColor: AppTheme.connectedEmerald,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: StatCard(
                          label: 'UPLOAD',
                          value: _formatSpeed(config.uploadSpeedKbps),
                          icon: Icons.arrow_upward_rounded,
                          iconColor: AppTheme.primaryCyan,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Live Protocol & IP Protection Info
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.surfaceLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.security_rounded,
                              color: AppTheme.connectedEmerald,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PROTOCOL & SECURITY',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${config.protocol.shortName} • 256-bit AES',
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.connectedEmerald.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'PROTECTED',
                            style: TextStyle(
                              color: AppTheme.connectedEmerald,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
