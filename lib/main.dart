import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'services/vpn_service.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PowerVpnApp());
}

class PowerVpnApp extends StatelessWidget {
  const PowerVpnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VpnService>(
      create: (_) => VpnService(),
      child: MaterialApp(
        title: 'PowerVPN',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const SplashScreen(),
      ),
    );
  }
}
