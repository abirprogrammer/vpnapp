import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'ip_checker_screen.dart';
import 'server_list_screen.dart';
import 'settings_screen.dart';
import 'speed_test_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        onNavigateToLocations: () => _onTabTapped(1),
        onNavigateToSpeedTest: () => _onTabTapped(2),
        onNavigateToIpChecker: () => _onTabTapped(3),
      ),
      const ServerListScreen(isEmbedded: true),
      const SpeedTestScreen(isEmbedded: true),
      const IpCheckerScreen(isEmbedded: true),
      const SettingsScreen(isEmbedded: true),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: const Border(
            top: BorderSide(color: AppTheme.surfaceLight, width: 1.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(80),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.primaryCyan,
              unselectedItemColor: AppTheme.textMuted,
              selectedFontSize: 12,
              unselectedFontSize: 11,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.shield_outlined),
                  activeIcon: Icon(Icons.shield_rounded),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.public_outlined),
                  activeIcon: Icon(Icons.public_rounded),
                  label: 'Locations',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.speed_outlined),
                  activeIcon: Icon(Icons.speed_rounded),
                  label: 'Speed Test',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.location_on_outlined),
                  activeIcon: Icon(Icons.location_on_rounded),
                  label: 'IP Check',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings_rounded),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
