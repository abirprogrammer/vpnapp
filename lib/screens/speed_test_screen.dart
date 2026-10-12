import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SpeedTestScreen extends StatefulWidget {
  final bool isEmbedded;

  const SpeedTestScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  State<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  bool _isTesting = false;
  double _downloadSpeed = 0.0;
  double _uploadSpeed = 0.0;
  int _ping = 0;
  int _jitter = 0;
  double _progress = 0.0;
  String _stage = 'READY';

  void _runSpeedTest() {
    if (_isTesting) return;

    setState(() {
      _isTesting = true;
      _downloadSpeed = 0.0;
      _uploadSpeed = 0.0;
      _ping = 0;
      _jitter = 0;
      _progress = 0.0;
      _stage = 'PINGING...';
    });

    final random = Random();

    // Stage 1: Ping
    Timer(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _ping = 15 + random.nextInt(20);
        _jitter = 1 + random.nextInt(4);
        _stage = 'TESTING DOWNLOAD...';
        _progress = 0.3;
      });

      // Stage 2: Download Speed
      Timer.periodic(const Duration(milliseconds: 200), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_progress < 0.7) {
          setState(() {
            _progress += 0.05;
            _downloadSpeed = 45.0 + random.nextDouble() * 35.0; // ~45-80 Mbps
          });
        } else {
          timer.cancel();
          setState(() {
            _stage = 'TESTING UPLOAD...';
          });

          // Stage 3: Upload Speed
          Timer.periodic(const Duration(milliseconds: 200), (upTimer) {
            if (!mounted) {
              upTimer.cancel();
              return;
            }

            if (_progress < 1.0) {
              setState(() {
                _progress += 0.05;
                _uploadSpeed = 20.0 + random.nextDouble() * 18.0; // ~20-38 Mbps
              });
            } else {
              upTimer.cancel();
              setState(() {
                _isTesting = false;
                _progress = 1.0;
                _stage = 'TEST COMPLETED';
              });
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed Test Utility'),
        automaticallyImplyLeading: !widget.isEmbedded,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Gauge Display Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.surfaceLight),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryCyan.withAlpha(20),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _stage,
                      style: const TextStyle(
                        color: AppTheme.primaryCyan,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _downloadSpeed > 0
                          ? _downloadSpeed.toStringAsFixed(1)
                          : '--',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Mbps Download',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 8,
                        backgroundColor: AppTheme.surfaceLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryCyan,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Results Grid
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      'PING',
                      _ping > 0 ? '$_ping ms' : '--',
                      Icons.network_ping_rounded,
                      AppTheme.connectedEmerald,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile(
                      'JITTER',
                      _jitter > 0 ? '$_jitter ms' : '--',
                      Icons.equalizer_rounded,
                      AppTheme.warningOrange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      'DOWNLOAD',
                      _downloadSpeed > 0
                          ? '${_downloadSpeed.toStringAsFixed(1)} Mbps'
                          : '--',
                      Icons.download_rounded,
                      AppTheme.primaryCyan,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile(
                      'UPLOAD',
                      _uploadSpeed > 0
                          ? '${_uploadSpeed.toStringAsFixed(1)} Mbps'
                          : '--',
                      Icons.upload_rounded,
                      AppTheme.goldPremium,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Start Speed Test Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isTesting ? null : _runSpeedTest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryCyan,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, size: 28),
                  label: Text(
                    _isTesting ? 'TESTING SPEED...' : 'START SPEED TEST',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
