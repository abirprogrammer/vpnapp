import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/server_model.dart';
import '../services/server_service.dart';
import '../services/vpn_service.dart';
import '../theme/app_theme.dart';
import '../widgets/server_card.dart';

class ServerListScreen extends StatefulWidget {
  final bool isEmbedded;

  const ServerListScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  State<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends State<ServerListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<ServerModel> _filterServers(List<ServerModel> servers) {
    if (_searchQuery.trim().isEmpty) return servers;
    final q = _searchQuery.toLowerCase();
    return servers.where((s) {
      return s.countryName.toLowerCase().contains(q) ||
          s.cityName.toLowerCase().contains(q) ||
          s.countryCode.toLowerCase().contains(q);
    }).toList();
  }

  void _onServerSelected(VpnService vpnService, ServerModel server) {
    vpnService.selectServer(server);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected ${server.countryName} (${server.cityName})'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.surface,
        behavior: SnackBarBehavior.floating,
      ),
    );
    if (!widget.isEmbedded && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vpnService = Provider.of<VpnService>(context);
    final selectedServer = vpnService.selectedServer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Server Locations'),
        automaticallyImplyLeading: !widget.isEmbedded,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryCyan,
          labelColor: AppTheme.primaryCyan,
          unselectedLabelColor: AppTheme.textSecondary,
          tabs: const [
            Tab(text: 'Recommended'),
            Tab(text: 'Fastest'),
            Tab(text: 'All'),
            Tab(text: 'VIP'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search country or city...',
                hintStyle: const TextStyle(color: AppTheme.textMuted),
                prefixIcon:
                    const Icon(Icons.search_rounded, color: AppTheme.textSecondary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded,
                            color: AppTheme.textSecondary),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppTheme.surfaceLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppTheme.surfaceLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppTheme.primaryCyan),
                ),
              ),
            ),
          ),

          // Smart Select Best Location Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                final best = ServerService.getSmartBestServer();
                _onServerSelected(vpnService, best);
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryCyan.withAlpha(38),
                      AppTheme.surface,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.primaryCyan.withAlpha(76),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.bolt_rounded, color: AppTheme.primaryCyan),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Auto-Select Smartest Location',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Connects to server with lowest latency & load',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: AppTheme.primaryCyan, size: 16),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // TabBar Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildServerList(
                    _filterServers(ServerService.getRecommendedServers()),
                    selectedServer,
                    vpnService),
                _buildServerList(
                    _filterServers(ServerService.getFastestServers()),
                    selectedServer,
                    vpnService),
                _buildServerList(
                    _filterServers(ServerService.getAllServers()),
                    selectedServer,
                    vpnService),
                _buildServerList(
                    _filterServers(ServerService.getPremiumServers()),
                    selectedServer,
                    vpnService),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerList(List<ServerModel> servers,
      ServerModel? selectedServer, VpnService vpnService) {
    if (servers.isEmpty) {
      return const Center(
        child: Text(
          'No servers found',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: servers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final server = servers[index];
        final isSelected = selectedServer?.id == server.id;

        return ServerCard(
          server: server,
          isSelected: isSelected,
          onTap: () => _onServerSelected(vpnService, server),
        );
      },
    );
  }
}
