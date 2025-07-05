import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swornim/pages/models/user/user.dart';
import 'package:swornim/pages/models/bookings/booking.dart';
import 'package:swornim/pages/models/bookings/service_package.dart';
import 'package:swornim/pages/providers/bookings/bookings_provider.dart';
import 'package:swornim/pages/providers/auth/auth_provider.dart';
import 'package:swornim/pages/layouts/main_layout.dart';
import 'package:swornim/pages/widgets/common/booking_card.dart';
import 'package:swornim/pages/dashboard/widgets/dashboard_overview.dart';
import 'package:swornim/pages/dashboard/widgets/bookings_management.dart';
import 'package:swornim/pages/dashboard/widgets/package_management.dart';
import 'package:swornim/pages/dashboard/widgets/calendar_view.dart';
import 'package:swornim/pages/dashboard/widgets/revenue_analytics.dart';
import 'package:swornim/pages/dashboard/widgets/profile_management.dart';
import 'package:swornim/pages/dashboard/dashboard_stats_provider.dart';
import 'package:swornim/pages/dashboard/providers/analytics_provider.dart';
import 'package:swornim/pages/components/common/common/profile/profile_panel.dart';
import 'package:swornim/pages/introduction/welcome_screen.dart';

class ServiceProviderDashboard extends ConsumerStatefulWidget {
  final User provider;
  const ServiceProviderDashboard({required this.provider, Key? key}) : super(key: key);

  @override
  ConsumerState<ServiceProviderDashboard> createState() => _ServiceProviderDashboardState();
}

class _ServiceProviderDashboardState extends ConsumerState<ServiceProviderDashboard> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  final List<Widget> _dashboardScreens = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MainLayout(
      showFooter: false,
      showAppBar: true,
      onNotificationTap: _handleNotificationTap,
      onProfileTap: _handleProfileTap,
      child: Column(
        children: [
          // Custom App Bar for Dashboard
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      child: Icon(
                        Icons.business,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.provider.name} Dashboard',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Manage your business and bookings',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'settings':
                            _handleSettingsTap();
                            break;
                          case 'logout':
                            _handleLogout();
                            break;
                        }
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'settings',
                          child: Row(
                            children: [
                              Icon(Icons.settings, size: 20, color: colorScheme.onSurfaceVariant),
                              const SizedBox(width: 12),
                              const Text('Settings'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, size: 20, color: Colors.red),
                              const SizedBox(width: 12),
                              const Text('Logout', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Tab Bar
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicator: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: colorScheme.onPrimary,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.dashboard, size: 20),
                        text: 'Overview',
                      ),
                      Tab(
                        icon: Icon(Icons.calendar_today, size: 20),
                        text: 'Bookings',
                      ),
                      Tab(
                        icon: Icon(Icons.inventory, size: 20),
                        text: 'Packages',
                      ),
                      Tab(
                        icon: Icon(Icons.calendar_month, size: 20),
                        text: 'Calendar',
                      ),
                      Tab(
                        icon: Icon(Icons.analytics, size: 20),
                        text: 'Analytics',
                      ),
                      Tab(
                        icon: Icon(Icons.person, size: 20),
                        text: 'Profile',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Dashboard Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                DashboardOverview(provider: widget.provider),
                BookingsManagement(provider: widget.provider),
                PackageManagement(provider: widget.provider),
                CalendarView(provider: widget.provider),
                RevenueAnalytics(provider: widget.provider),
                ProfileManagement(provider: widget.provider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notifications'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleProfileTap() {
    showDialog(
      context: context,
      builder: (context) => const ProfilePanel(),
    );
  }

  void _handleSettingsTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Dashboard Settings'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: Colors.red.shade600,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Sign Out',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to sign out of your account?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                
                // Perform logout
                await ref.read(authProvider.notifier).logout();
                
                // Explicitly navigate to WelcomeScreen and clear navigation stack
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
} 