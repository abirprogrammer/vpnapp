import '../models/server_model.dart';

class ServerService {
  static final List<ServerModel> _allServers = [
    const ServerModel(
      id: 'us_ny_01',
      countryName: 'United States',
      countryCode: 'US',
      flagEmoji: '🇺🇸',
      cityName: 'New York',
      ipAddress: '104.28.19.102',
      ping: 18,
      serverLoad: 32,
      isPremium: false,
      isRecommended: true,
      protocol: 'WireGuard',
    ),
    const ServerModel(
      id: 'us_la_02',
      countryName: 'United States',
      countryCode: 'US',
      flagEmoji: '🇺🇸',
      cityName: 'Los Angeles',
      ipAddress: '198.51.100.45',
      ping: 24,
      serverLoad: 45,
      isPremium: false,
      isRecommended: true,
      protocol: 'WireGuard',
    ),
    const ServerModel(
      id: 'uk_ldn_01',
      countryName: 'United Kingdom',
      countryCode: 'GB',
      flagEmoji: '🇬🇧',
      cityName: 'London',
      ipAddress: '185.220.101.5',
      ping: 28,
      serverLoad: 29,
      isPremium: false,
      isRecommended: true,
      protocol: 'WireGuard',
    ),
    const ServerModel(
      id: 'de_fra_01',
      countryName: 'Germany',
      countryCode: 'DE',
      flagEmoji: '🇩🇪',
      cityName: 'Frankfurt',
      ipAddress: '149.154.158.20',
      ping: 22,
      serverLoad: 25,
      isPremium: false,
      isRecommended: true,
      protocol: 'WireGuard',
    ),
    const ServerModel(
      id: 'sg_sin_01',
      countryName: 'Singapore',
      countryCode: 'SG',
      flagEmoji: '🇸🇬',
      cityName: 'Singapore City',
      ipAddress: '128.199.200.12',
      ping: 35,
      serverLoad: 40,
      isPremium: false,
      isRecommended: true,
      protocol: 'WireGuard',
    ),
    const ServerModel(
      id: 'jp_tyo_01',
      countryName: 'Japan',
      countryCode: 'JP',
      flagEmoji: '🇯🇵',
      cityName: 'Tokyo',
      ipAddress: '106.187.98.11',
      ping: 42,
      serverLoad: 55,
      isPremium: false,
      isRecommended: false,
      protocol: 'WireGuard',
    ),
    const ServerModel(
      id: 'ca_tor_01',
      countryName: 'Canada',
      countryCode: 'CA',
      flagEmoji: '🇨🇦',
      cityName: 'Toronto',
      ipAddress: '192.99.14.88',
      ping: 30,
      serverLoad: 38,
      isPremium: false,
      isRecommended: false,
      protocol: 'WireGuard',
    ),
    const ServerModel(
      id: 'nl_ams_01',
      countryName: 'Netherlands',
      countryCode: 'NL',
      flagEmoji: '🇳🇱',
      cityName: 'Amsterdam',
      ipAddress: '95.211.230.1',
      ping: 20,
      serverLoad: 21,
      isPremium: false,
      isRecommended: true,
      protocol: 'WireGuard',
    ),
    const ServerModel(
      id: 'au_syd_01',
      countryName: 'Australia',
      countryCode: 'AU',
      flagEmoji: '🇦🇺',
      cityName: 'Sydney',
      ipAddress: '139.99.130.5',
      ping: 85,
      serverLoad: 60,
      isPremium: true,
      isRecommended: false,
      protocol: 'WireGuard',
    ),
    const ServerModel(
      id: 'fr_par_01',
      countryName: 'France',
      countryCode: 'FR',
      flagEmoji: '🇫🇷',
      cityName: 'Paris',
      ipAddress: '51.15.20.100',
      ping: 26,
      serverLoad: 31,
      isPremium: true,
      isRecommended: false,
      protocol: 'WireGuard',
    ),
    const ServerModel(
      id: 'in_mum_01',
      countryName: 'India',
      countryCode: 'IN',
      flagEmoji: '🇮🇳',
      cityName: 'Mumbai',
      ipAddress: '13.232.12.90',
      ping: 50,
      serverLoad: 48,
      isPremium: false,
      isRecommended: false,
      protocol: 'WireGuard',
    ),
    const ServerModel(
      id: 'br_sao_01',
      countryName: 'Brazil',
      countryCode: 'BR',
      flagEmoji: '🇧🇷',
      cityName: 'Sao Paulo',
      ipAddress: '177.54.144.2',
      ping: 110,
      serverLoad: 68,
      isPremium: true,
      isRecommended: false,
      protocol: 'WireGuard',
    ),
    const ServerModel(
      id: 'kr_seo_01',
      countryName: 'South Korea',
      countryCode: 'KR',
      flagEmoji: '🇰🇷',
      cityName: 'Seoul',
      ipAddress: '211.233.72.10',
      ping: 45,
      serverLoad: 34,
      isPremium: true,
      isRecommended: false,
      protocol: 'WireGuard',
    ),
    const ServerModel(
      id: 'ch_zur_01',
      countryName: 'Switzerland',
      countryCode: 'CH',
      flagEmoji: '🇨🇭',
      cityName: 'Zurich',
      ipAddress: '179.43.140.22',
      ping: 23,
      serverLoad: 18,
      isPremium: true,
      isRecommended: true,
      protocol: 'WireGuard',
    ),
  ];

  static List<ServerModel> getAllServers() {
    return List.unmodifiable(_allServers);
  }

  static List<ServerModel> getRecommendedServers() {
    return _allServers.where((s) => s.isRecommended).toList();
  }

  static List<ServerModel> getFastestServers() {
    final sorted = List<ServerModel>.from(_allServers);
    sorted.sort((a, b) => a.ping.compareTo(b.ping));
    return sorted;
  }

  static List<ServerModel> getFreeServers() {
    return _allServers.where((s) => !s.isPremium).toList();
  }

  static List<ServerModel> getPremiumServers() {
    return _allServers.where((s) => s.isPremium).toList();
  }

  static ServerModel getSmartBestServer() {
    final sorted = List<ServerModel>.from(_allServers.where((s) => !s.isPremium));
    sorted.sort((a, b) => a.ping.compareTo(b.ping));
    return sorted.first;
  }

  static List<ServerModel> searchServers(String query) {
    if (query.trim().isEmpty) return _allServers;
    final q = query.toLowerCase();
    return _allServers.where((s) {
      return s.countryName.toLowerCase().contains(q) ||
          s.cityName.toLowerCase().contains(q) ||
          s.countryCode.toLowerCase().contains(q);
    }).toList();
  }
}
