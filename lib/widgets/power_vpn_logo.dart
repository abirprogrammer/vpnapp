import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PowerVpnLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const PowerVpnLogo({
    super.key,
    this.size = 36.0,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                AppTheme.primaryCyan,
                Color(0xFF00B0FF),
                Color(0xFF0077FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryCyan.withAlpha(100),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.bolt_rounded,
              color: Colors.black,
              size: size * 0.65,
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: size * 0.58,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                fontFamily: 'Outfit',
              ),
              children: const [
                TextSpan(
                  text: 'POWER',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                TextSpan(
                  text: 'VPN',
                  style: TextStyle(color: AppTheme.primaryCyan),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
