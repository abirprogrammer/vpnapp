import 'package:flutter/material.dart';
import '../models/server_model.dart';
import '../theme/app_theme.dart';

class ServerCard extends StatelessWidget {
  final ServerModel server;
  final bool isSelected;
  final VoidCallback onTap;

  const ServerCard({
    super.key,
    required this.server,
    required this.isSelected,
    required this.onTap,
  });

  Color _getPingColor(int ping) {
    if (ping < 35) return AppTheme.connectedEmerald;
    if (ping < 80) return AppTheme.warningOrange;
    return AppTheme.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    final pingColor = _getPingColor(server.ping);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryCyan.withAlpha(20) : AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryCyan : AppTheme.surfaceLight,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Country Flag Emoji Container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                server.flagEmoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 14),

            // Country & City Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          server.countryName,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (server.isPremium) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.goldPremium.withAlpha(50),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppTheme.goldPremium, width: 0.8),
                          ),
                          child: const Text(
                            'VIP',
                            style: TextStyle(
                              color: AppTheme.goldPremium,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${server.cityName} • ${server.ipAddress}',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Ping Badge & Load Meter
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.network_ping_rounded,
                      size: 14,
                      color: pingColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${server.ping} ms',
                      style: TextStyle(
                        color: pingColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Load ${server.serverLoad}%',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),

            // Radio / Check Icon
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected ? AppTheme.primaryCyan : AppTheme.textMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
