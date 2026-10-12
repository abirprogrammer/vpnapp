import 'server_model.dart';

enum VpnState {
  disconnected,
  connecting,
  connected,
  disconnecting,
}

enum VpnProtocol {
  wireguard,
  openVpnUdp,
  openVpnTcp,
}

extension VpnProtocolExtension on VpnProtocol {
  String get displayName {
    switch (this) {
      case VpnProtocol.wireguard:
        return 'WireGuard (Fastest & Secure)';
      case VpnProtocol.openVpnUdp:
        return 'OpenVPN (UDP)';
      case VpnProtocol.openVpnTcp:
        return 'OpenVPN (TCP)';
    }
  }

  String get shortName {
    switch (this) {
      case VpnProtocol.wireguard:
        return 'WireGuard';
      case VpnProtocol.openVpnUdp:
        return 'OpenVPN UDP';
      case VpnProtocol.openVpnTcp:
        return 'OpenVPN TCP';
    }
  }
}

class VpnConfigModel {
  final VpnState state;
  final ServerModel? selectedServer;
  final Duration duration;
  final int byteIn; // Download bytes
  final int byteOut; // Upload bytes
  final double downloadSpeedKbps;
  final double uploadSpeedKbps;
  final VpnProtocol protocol;
  final bool killSwitchEnabled;
  final bool splitTunnelingEnabled;
  final bool autoConnectWifi;
  final bool dnsLeakProtection;

  const VpnConfigModel({
    this.state = VpnState.disconnected,
    this.selectedServer,
    this.duration = Duration.zero,
    this.byteIn = 0,
    this.byteOut = 0,
    this.downloadSpeedKbps = 0.0,
    this.uploadSpeedKbps = 0.0,
    this.protocol = VpnProtocol.wireguard,
    this.killSwitchEnabled = true,
    this.splitTunnelingEnabled = false,
    this.autoConnectWifi = false,
    this.dnsLeakProtection = true,
  });

  VpnConfigModel copyWith({
    VpnState? state,
    ServerModel? selectedServer,
    Duration? duration,
    int? byteIn,
    int? byteOut,
    double? downloadSpeedKbps,
    double? uploadSpeedKbps,
    VpnProtocol? protocol,
    bool? killSwitchEnabled,
    bool? splitTunnelingEnabled,
    bool? autoConnectWifi,
    bool? dnsLeakProtection,
  }) {
    return VpnConfigModel(
      state: state ?? this.state,
      selectedServer: selectedServer ?? this.selectedServer,
      duration: duration ?? this.duration,
      byteIn: byteIn ?? this.byteIn,
      byteOut: byteOut ?? this.byteOut,
      downloadSpeedKbps: downloadSpeedKbps ?? this.downloadSpeedKbps,
      uploadSpeedKbps: uploadSpeedKbps ?? this.uploadSpeedKbps,
      protocol: protocol ?? this.protocol,
      killSwitchEnabled: killSwitchEnabled ?? this.killSwitchEnabled,
      splitTunnelingEnabled:
          splitTunnelingEnabled ?? this.splitTunnelingEnabled,
      autoConnectWifi: autoConnectWifi ?? this.autoConnectWifi,
      dnsLeakProtection: dnsLeakProtection ?? this.dnsLeakProtection,
    );
  }
}
