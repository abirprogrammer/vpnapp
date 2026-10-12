import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/server_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
    _isInitialized = true;
  }

  static Future<void> showConnectedNotification(ServerModel server) async {
    try {
      await init();
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'powervpn_channel_id',
        'PowerVPN Connection Status',
        channelDescription: 'Shows active VPN connection status and security info',
        importance: Importance.high,
        priority: Priority.high,
        ongoing: true,
        autoCancel: false,
        icon: '@mipmap/ic_launcher',
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        0,
        'PowerVPN Connected 🛡️',
        'Connected to ${server.countryName} (${server.cityName}) • IP: ${server.ipAddress}',
        platformChannelSpecifics,
      );
    } catch (_) {
      // Fallback if notifications are disabled or platform doesn't support
    }
  }

  static Future<void> showDisconnectedNotification() async {
    try {
      await init();
      // Cancel persistent connected notification
      await _notificationsPlugin.cancel(0);

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'powervpn_channel_id',
        'PowerVPN Connection Status',
        channelDescription: 'Shows active VPN connection status and security info',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        1,
        'PowerVPN Disconnected ⚠️',
        'Your internet connection is no longer protected by VPN.',
        platformChannelSpecifics,
      );
    } catch (_) {
      // Fallback
    }
  }
}
