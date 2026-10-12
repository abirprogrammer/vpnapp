import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PremiumScreen extends StatefulWidget {
  final bool isEmbedded;

  const PremiumScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  int _selectedPlanIndex = 1; // Default 1 Year plan

  final List<Map<String, String>> _plans = [
    {
      'title': '1 Month VIP',
      'price': '\$9.99',
      'subtext': '\$9.99 / month',
      'badge': '',
    },
    {
      'title': '1 Year VIP',
      'price': '\$3.99',
      'subtext': '\$47.88 / year (Save 60%)',
      'badge': 'BEST VALUE',
    },
    {
      'title': '2 Year VIP',
      'price': '\$2.49',
      'subtext': '\$59.76 / 2 years (Save 75%)',
      'badge': 'POPULAR',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PowerVPN VIP Pass'),
        automaticallyImplyLeading: !widget.isEmbedded,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // VIP Crown Banner
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppTheme.goldPremium.withAlpha(38),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.goldPremium, width: 2),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: AppTheme.goldPremium,
                  size: 44,
                ),
              ),
              const SizedBox(height: 14),

              const Text(
                'Unlock Ultimate Speed & Protection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Get unlimited access to 100+ ultra-fast global 10Gbps servers with zero ads.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              // Feature Highlights List
              _buildFeatureRow('⚡ 10Gbps Ultra Fast Servers across 60+ countries'),
              _buildFeatureRow('🛡️ Ad-Free Experience & Malware Blocker'),
              _buildFeatureRow('🎬 Seamless Streaming & Low Latency Gaming'),
              _buildFeatureRow('📱 Connect up to 10 Devices simultaneously'),
              _buildFeatureRow('🔒 Dedicated IP & AES-256 Military Encryption'),

              const SizedBox(height: 28),

              // Subscription Plans List
              ...List.generate(_plans.length, (index) {
                final plan = _plans[index];
                final isSelected = _selectedPlanIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPlanIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.goldPremium.withAlpha(25)
                          : AppTheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.goldPremium
                            : AppTheme.surfaceLight,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: isSelected
                              ? AppTheme.goldPremium
                              : AppTheme.textMuted,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    plan['title']!,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (plan['badge']!.isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.goldPremium,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        plan['badge']!,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                plan['subtext']!,
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          plan['price']!,
                          style: const TextStyle(
                            color: AppTheme.goldPremium,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Subscribe CTA Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Thank you! Play Store In-App Billing ready.'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.goldPremium,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'UNLOCK ALL SERVERS NOW',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const Text(
                'Cancel anytime in Google Play Store settings.',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
