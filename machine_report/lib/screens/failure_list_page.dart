import 'package:flutter/material.dart';

import '../models/failure_report.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/failure_service.dart';
import '../theme/app_theme.dart';

class FailureListPage extends StatefulWidget {
  const FailureListPage({super.key});

  @override
  State<FailureListPage> createState() => _FailureListPageState();
}

class _FailureListPageState extends State<FailureListPage> {
  String _searchQuery = '';
  FailureType? _selectedFilter;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out from the system?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE11D48)),
            onPressed: () {
              Navigator.of(ctx).pop();
              AuthService.instance.logout();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _deleteReport(FailureReport report) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFE11D48)),
            SizedBox(width: 8),
            Text('Resolve Incident'),
          ],
        ),
        content: Text('Are you sure you want to mark this incident on "${report.machineName}" as resolved and remove it from the active report list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE11D48)),
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                FailureService.instance.remove(report.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Incident on ${report.machineName} resolved.'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: const Text('Resolve & Remove'),
          ),
        ],
      ),
    );
  }

  List<FailureReport> _getFilteredReports() {
    final reports = FailureService.instance.reports;
    return reports.where((report) {
      final matchesSearch = _searchQuery.isEmpty ||
          report.machineName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          report.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (report.reportedBy != null &&
              report.reportedBy!.toLowerCase().contains(_searchQuery.toLowerCase()));

      final matchesType = _selectedFilter == null || report.failureType == _selectedFilter;

      return matchesSearch && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allReports = FailureService.instance.reports;
    final filteredReports = _getFilteredReports();
    final user = AuthService.instance.currentUser;
    final isAdmin = AuthService.instance.isAdmin;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.precision_manufacturing_rounded,
                color: AppTheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Failure Reports',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.slateDark,
                    letterSpacing: -0.4,
                  ),
                ),
                Text(
                  'Incident & Equipment Monitoring',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.slateLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // User Role Pill
          if (user != null)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isAdmin
                    ? const Color(0xFF4F46E5).withValues(alpha: 0.1)
                    : const Color(0xFF0284C7).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isAdmin
                      ? const Color(0xFF4F46E5).withValues(alpha: 0.3)
                      : const Color(0xFF0284C7).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isAdmin ? Icons.shield_rounded : Icons.handyman_rounded,
                    size: 14,
                    color: isAdmin ? AppTheme.primary : const Color(0xFF0284C7),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    user.username,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: isAdmin ? AppTheme.primary : const Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${user.role == UserRole.administrator ? "Admin" : "Tech"})',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.slateLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Sign Out',
            icon: const Icon(Icons.logout_rounded, color: AppTheme.slateMedium, size: 22),
            onPressed: _logout,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Top Metrics Dashboard
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _buildMetricsSection(allReports),
            ),
          ),

          // Search and Filter Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Box
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val.trim()),
                    decoration: InputDecoration(
                      hintText: 'Search by equipment, keywords, or reporter...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.slateLight),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          label: 'All (${allReports.length})',
                          isSelected: _selectedFilter == null,
                          onSelected: () => setState(() => _selectedFilter = null),
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 8),
                        ...FailureType.values.map((type) {
                          final count = allReports.where((r) => r.failureType == type).length;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildFilterChip(
                              label: '${type.label} ($count)',
                              icon: AppTheme.getTypeIcon(type),
                              isSelected: _selectedFilter == type,
                              onSelected: () => setState(() {
                                _selectedFilter = _selectedFilter == type ? null : type;
                              }),
                              color: AppTheme.getTypeColor(type),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // List of Reports or Empty State
          if (filteredReports.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(allReports.isEmpty),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final report = filteredReports[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildFailureCard(report, isAdmin),
                    );
                  },
                  childCount: filteredReports.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.of(context).pushNamed('/create');
                if (mounted) setState(() {});
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                'New Failure',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            )
          : null,
    );
  }

  Widget _buildMetricsSection(List<FailureReport> reports) {
    final mechanicalCount = reports.where((r) => r.failureType == FailureType.mechanical).length;
    final electricalCount = reports.where((r) => r.failureType == FailureType.electrical).length;
    final hydraulicCount = reports.where((r) => r.failureType == FailureType.hydraulic).length;
    final softwareCount = reports.where((r) => r.failureType == FailureType.software).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.slateBorder),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.insights_rounded, size: 18, color: AppTheme.primary),
                  SizedBox(width: 8),
                  Text(
                    'Incident Overview',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.slateDark,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${reports.length} Total Active',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildMiniMetricItem('Mechanical', mechanicalCount, AppTheme.mechanicalColor, Icons.settings_rounded),
              _buildMiniMetricItem('Electrical', electricalCount, AppTheme.electricalColor, Icons.bolt_rounded),
              _buildMiniMetricItem('Hydraulic', hydraulicCount, AppTheme.hydraulicColor, Icons.water_drop_rounded),
              _buildMiniMetricItem('Software', softwareCount, AppTheme.softwareColor, Icons.code_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetricItem(String label, int count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.slateLight,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onSelected,
    required Color color,
  }) {
    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : AppTheme.slateBorder,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : color,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.slateDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFailureCard(FailureReport report, bool isAdmin) {
    final typeColor = AppTheme.getTypeColor(report.failureType);
    final typeIcon = AppTheme.getTypeIcon(report.failureType);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.slateBorder),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored left accent stripe
              Container(
                width: 5,
                color: typeColor,
              ),

              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Machine Name + Type Pill Badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: typeColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(typeIcon, color: typeColor, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  report.machineName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.slateDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatRelativeTime(report.reportedAt),
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppTheme.slateLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Type Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: typeColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: typeColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              report.failureType.label,
                              style: TextStyle(
                                color: typeColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Description
                      Text(
                        report.description,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.45,
                          color: AppTheme.slateMedium,
                        ),
                      ),
                      const SizedBox(height: 14),

                      const Divider(height: 1),
                      const SizedBox(height: 10),

                      // Footer Row: Metadata & Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (report.reportedBy != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppTheme.backgroundLight,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppTheme.slateBorder),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.person_outline_rounded, size: 13, color: AppTheme.slateLight),
                                      const SizedBox(width: 4),
                                      Text(
                                        'By ${report.reportedBy}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.slateMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 12, color: AppTheme.slateLight),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatFullDate(report.reportedAt),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.slateLight,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Admin Resolve Button
                          if (isAdmin)
                            InkWell(
                              onTap: () => _deleteReport(report),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE11D48).withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFE11D48).withValues(alpha: 0.2),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle_outline_rounded, size: 14, color: Color(0xFFE11D48)),
                                    SizedBox(width: 4),
                                    Text(
                                      'Resolve',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFE11D48),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isCompletelyEmpty) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isCompletelyEmpty
                    ? const Color(0xFF10B981).withValues(alpha: 0.1)
                    : AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompletelyEmpty
                    ? Icons.check_circle_outline_rounded
                    : Icons.search_off_rounded,
                size: 48,
                color: isCompletelyEmpty
                    ? const Color(0xFF10B981)
                    : AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isCompletelyEmpty
                  ? 'All Systems Operational'
                  : 'No Incidents Found',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.slateDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isCompletelyEmpty
                  ? 'There are currently no active failure reports in the registry.'
                  : 'No failure reports match your active search and filter criteria.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppTheme.slateLight,
              ),
            ),
            if (!isCompletelyEmpty) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _selectedFilter = null;
                  });
                },
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Clear Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatRelativeTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 60) {
      return diff.inMinutes <= 1 ? 'Just now' : '${diff.inMinutes} mins ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${diff.inDays} days ago';
    }
  }

  String _formatFullDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
