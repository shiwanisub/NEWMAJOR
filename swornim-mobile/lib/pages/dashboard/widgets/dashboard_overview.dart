import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swornim/pages/models/user/user.dart';
import 'package:swornim/pages/models/bookings/booking.dart';
import 'package:swornim/pages/providers/bookings/bookings_provider.dart';
import 'package:swornim/pages/dashboard/dashboard_stats_provider.dart';
import 'package:swornim/pages/widgets/common/booking_card.dart';

class DashboardOverview extends ConsumerWidget {
  final User provider;
  
  const DashboardOverview({required this.provider, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bookingsState = ref.watch(bookingsProvider);
    final dashboardStats = ref.watch(dashboardStatsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _buildWelcomeSection(theme, colorScheme),
          const SizedBox(height: 32),

          // Key Metrics Cards
          _buildMetricsCards(theme, colorScheme, dashboardStats),
          const SizedBox(height: 32),

          // Quick Stats Row
          _buildQuickStatsRow(theme, colorScheme, dashboardStats),
          const SizedBox(height: 32),

          // Upcoming Events
          _buildUpcomingEvents(theme, colorScheme, bookingsState),
          const SizedBox(height: 32),

          // Recent Booking Requests
          _buildRecentRequests(theme, colorScheme, bookingsState),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.12),
            colorScheme.primary.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.celebration,
              color: colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, ${provider.name}!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Here\'s what\'s happening with your business today',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsCards(ThemeData theme, ColorScheme colorScheme, DashboardStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 20),
          child: Text(
            'Key Metrics',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.15,
          children: [
            _buildMetricCard(
              theme,
              colorScheme,
              'Total Bookings',
              '${stats.totalBookings}',
              Icons.calendar_today_rounded,
              colorScheme.primary,
            ),
            _buildMetricCard(
              theme,
              colorScheme,
              'Pending Requests',
              '${stats.pendingRequests}',
              Icons.pending_actions_rounded,
              Colors.orange.shade600,
            ),
            _buildMetricCard(
              theme,
              colorScheme,
              'Monthly Revenue',
              '\$${stats.monthlyEarnings.toStringAsFixed(0)}',
              Icons.attach_money_rounded,
              Colors.green.shade600,
            ),
            _buildMetricCard(
              theme,
              colorScheme,
              'Upcoming Events',
              '${stats.upcomingEvents}',
              Icons.event_rounded,
              colorScheme.secondary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    ThemeData theme,
    ColorScheme colorScheme,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  color: Colors.green.shade600,
                  size: 16,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsRow(ThemeData theme, ColorScheme colorScheme, DashboardStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 20),
          child: Text(
            'Quick Stats',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildQuickStatCard(
                theme,
                colorScheme,
                'Completion Rate',
                '${_calculateCompletionRate(stats)}%',
                Icons.check_circle_rounded,
                Colors.green.shade600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickStatCard(
                theme,
                colorScheme,
                'Average Rating',
                '4.8',
                Icons.star_rounded,
                Colors.amber.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickStatCard(
    ThemeData theme,
    ColorScheme colorScheme,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents(ThemeData theme, ColorScheme colorScheme, BookingsState bookingsState) {
    final upcomingBookings = bookingsState.bookings
        .where((booking) => booking.isUpcoming)
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, bottom: 20),
          child: Row(
            children: [
              Text(
                'Upcoming Events',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  // Navigate to full bookings view
                },
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                ),
                label: const Text('View All'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ),
        if (upcomingBookings.isEmpty)
          _buildEmptyState(
            theme,
            colorScheme,
            'No upcoming events',
            'You have no scheduled events in the next 7 days',
            Icons.event_busy_rounded,
          )
        else
          Column(
            children: upcomingBookings.map((booking) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildEventCard(theme, colorScheme, booking),
              ),
            ).toList(),
          ),
      ],
    );
  }

  Widget _buildEventCard(ThemeData theme, ColorScheme colorScheme, Booking booking) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getServiceTypeIcon(booking.serviceType),
              color: colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.eventType,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${booking.formattedEventDate} at ${booking.eventTime}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        booking.eventLocation,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                booking.formattedAmount,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking.status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  booking.status.name.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _getStatusColor(booking.status),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRequests(ThemeData theme, ColorScheme colorScheme, BookingsState bookingsState) {
    final pendingBookings = bookingsState.bookings
        .where((booking) => booking.isPending)
        .take(2)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, bottom: 20),
          child: Row(
            children: [
              Text(
                'Recent Booking Requests',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  // Navigate to bookings management
                },
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                ),
                label: const Text('View All'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ),
        if (pendingBookings.isEmpty)
          _buildEmptyState(
            theme,
            colorScheme,
            'No pending requests',
            'All booking requests have been processed',
            Icons.check_circle_rounded,
          )
        else
          Column(
            children: pendingBookings.map((booking) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: BookingCard(booking: booking, currentUser: provider),
              ),
            ).toList(),
          ),
      ],
    );
  }

  Widget _buildEmptyState(
    ThemeData theme,
    ColorScheme colorScheme,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: colorScheme.onSurfaceVariant,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int _calculateCompletionRate(DashboardStats stats) {
    if (stats.totalBookings == 0) return 0;
    final completed = stats.statusBreakdown[BookingStatus.completed] ?? 0;
    return ((completed / stats.totalBookings) * 100).round();
  }

  IconData _getServiceTypeIcon(ServiceType serviceType) {
    switch (serviceType) {
      case ServiceType.photography:
        return Icons.camera_alt_rounded;
      case ServiceType.makeup:
        return Icons.face_rounded;
      case ServiceType.decoration:
        return Icons.celebration_rounded;
      case ServiceType.venue:
        return Icons.location_on_rounded;
      case ServiceType.catering:
        return Icons.restaurant_rounded;
      case ServiceType.music:
        return Icons.music_note_rounded;
      case ServiceType.planning:
        return Icons.event_note_rounded;
    }
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange.shade600;
      case BookingStatus.confirmed:
        return Colors.blue.shade600;
      case BookingStatus.inProgress:
        return Colors.purple.shade600;
      case BookingStatus.completed:
        return Colors.green.shade600;
      case BookingStatus.cancelled:
        return Colors.red.shade600;
      case BookingStatus.rejected:
        return Colors.red.shade600;
    }
  }
}