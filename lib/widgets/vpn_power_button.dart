import 'package:flutter/material.dart';
import '../models/vpn_config_model.dart';
import '../theme/app_theme.dart';

class VpnPowerButton extends StatefulWidget {
  final VpnState state;
  final VoidCallback onTap;

  const VpnPowerButton({
    super.key,
    required this.state,
    required this.onTap,
  });

  @override
  State<VpnPowerButton> createState() => _VpnPowerButtonState();
}

class _VpnPowerButtonState extends State<VpnPowerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _handleAnimation();
  }

  @override
  void didUpdateWidget(covariant VpnPowerButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _handleAnimation();
    }
  }

  void _handleAnimation() {
    if (widget.state == VpnState.connected ||
        widget.state == VpnState.connecting) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _glowColor {
    switch (widget.state) {
      case VpnState.connected:
        return AppTheme.connectedEmerald;
      case VpnState.connecting:
      case VpnState.disconnecting:
        return AppTheme.warningOrange;
      case VpnState.disconnected:
        return AppTheme.primaryCyan;
    }
  }

  String get _statusText {
    switch (widget.state) {
      case VpnState.connected:
        return 'CONNECTED';
      case VpnState.connecting:
        return 'CONNECTING...';
      case VpnState.disconnecting:
        return 'DISCONNECTING...';
      case VpnState.disconnected:
        return 'TAP TO CONNECT';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          final scale = (widget.state == VpnState.connected ||
                  widget.state == VpnState.connecting)
              ? _pulseAnimation.value
              : 1.0;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Glow Pulse Ring 2
                  Transform.scale(
                    scale: scale * 1.15,
                    child: Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _glowColor.withAlpha(15),
                      ),
                    ),
                  ),
                  // Outer Glow Pulse Ring 1
                  Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _glowColor.withAlpha(30),
                        boxShadow: [
                          BoxShadow(
                            color: _glowColor.withAlpha(90),
                            blurRadius: 30,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Main Dial Button
                  Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.surfaceLight,
                          AppTheme.surface,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: _glowColor,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _glowColor.withAlpha(128),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.power_settings_new_rounded,
                      size: 56,
                      color: _glowColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Status Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: _glowColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _glowColor.withAlpha(75),
                  ),
                ),
                child: Text(
                  _statusText,
                  style: TextStyle(
                    color: _glowColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
