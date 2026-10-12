class ServerModel {
  final String id;
  final String countryName;
  final String countryCode;
  final String flagEmoji;
  final String cityName;
  final String ipAddress;
  final int ping; // Ping in ms
  final int serverLoad; // Server load percentage (0 - 100)
  final bool isPremium;
  final bool isRecommended;
  final String protocol;
  final String ovpnConfig;

  const ServerModel({
    required this.id,
    required this.countryName,
    required this.countryCode,
    required this.flagEmoji,
    required this.cityName,
    required this.ipAddress,
    required this.ping,
    required this.serverLoad,
    this.isPremium = false,
    this.isRecommended = false,
    this.protocol = 'WireGuard',
    this.ovpnConfig = '',
  });

  ServerModel copyWith({
    String? id,
    String? countryName,
    String? countryCode,
    String? flagEmoji,
    String? cityName,
    String? ipAddress,
    int? ping,
    int? serverLoad,
    bool? isPremium,
    bool? isRecommended,
    String? protocol,
    String? ovpnConfig,
  }) {
    return ServerModel(
      id: id ?? this.id,
      countryName: countryName ?? this.countryName,
      countryCode: countryCode ?? this.countryCode,
      flagEmoji: flagEmoji ?? this.flagEmoji,
      cityName: cityName ?? this.cityName,
      ipAddress: ipAddress ?? this.ipAddress,
      ping: ping ?? this.ping,
      serverLoad: serverLoad ?? this.serverLoad,
      isPremium: isPremium ?? this.isPremium,
      isRecommended: isRecommended ?? this.isRecommended,
      protocol: protocol ?? this.protocol,
      ovpnConfig: ovpnConfig ?? this.ovpnConfig,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'countryName': countryName,
      'countryCode': countryCode,
      'flagEmoji': flagEmoji,
      'cityName': cityName,
      'ipAddress': ipAddress,
      'ping': ping,
      'serverLoad': serverLoad,
      'isPremium': isPremium,
      'isRecommended': isRecommended,
      'protocol': protocol,
      'ovpnConfig': ovpnConfig,
    };
  }

  factory ServerModel.fromJson(Map<String, dynamic> json) {
    return ServerModel(
      id: json['id'] as String? ?? '',
      countryName: json['countryName'] as String? ?? 'Unknown',
      countryCode: json['countryCode'] as String? ?? 'UN',
      flagEmoji: json['flagEmoji'] as String? ?? '🌐',
      cityName: json['cityName'] as String? ?? 'Auto',
      ipAddress: json['ipAddress'] as String? ?? '127.0.0.1',
      ping: json['ping'] as int? ?? 99,
      serverLoad: json['serverLoad'] as int? ?? 50,
      isPremium: json['isPremium'] as bool? ?? false,
      isRecommended: json['isRecommended'] as bool? ?? false,
      protocol: json['protocol'] as String? ?? 'WireGuard',
      ovpnConfig: json['ovpnConfig'] as String? ?? '',
    );
  }
}
