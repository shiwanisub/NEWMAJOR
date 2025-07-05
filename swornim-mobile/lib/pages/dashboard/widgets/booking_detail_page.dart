import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swornim/pages/models/user/user.dart';
import 'package:swornim/pages/models/bookings/booking.dart';
import 'package:swornim/pages/models/user/user_types.dart';
import 'package:swornim/pages/providers/bookings/bookings_provider.dart';

class BookingDetailPage extends ConsumerStatefulWidget {
  final Booking booking;
  final User provider;
  
  const BookingDetailPage({
    required this.booking,
    required this.provider,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends ConsumerState<BookingDetailPage> {
  bool _isUpdatingStatus = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking #${widget.booking.id.substring(0, 8)}'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showBookingMenu(context),
            icon: const Icon(Icons.more_vert),
            tooltip: 'More options',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Status Header
            _buildStatusHeader(theme, colorScheme),
            const SizedBox(height: 24),

            // Client Information
            _buildClientSection(theme, colorScheme),
            const SizedBox(height: 24),

            // Event Details
            _buildEventSection(theme, colorScheme),
            const SizedBox(height: 24),

            // Package Details
            _buildPackageSection(theme, colorScheme),
            const SizedBox(height: 24),

            // Payment Information
            _buildPaymentSection(theme, colorScheme),
            const SizedBox(height: 24),

            // Booking Timeline
            _buildTimelineSection(theme, colorScheme),
            const SizedBox(height: 24),

            // Special Requests
            if (widget.booking.specialRequests != null && 
                widget.booking.specialRequests!.isNotEmpty)
              _buildSpecialRequestsSection(theme, colorScheme),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(theme, colorScheme),
    );
  }

  Widget _buildStatusHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getStatusColor(widget.booking.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(widget.booking.status).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getStatusColor(widget.booking.status),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getStatusIcon(widget.booking.status),
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.booking.status.name.toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(widget.booking.status),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStatusDescription(widget.booking.status),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.booking.formattedAmount,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                'Total Amount',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientSection(ThemeData theme, ColorScheme colorScheme) {
    final client = widget.booking.client;
    
    return _buildSection(
      theme: theme,
      colorScheme: colorScheme,
      title: 'Client Information',
      icon: Icons.person,
      child: Column(
        children: [
          if (client != null) ...[
            _buildInfoRow('Name', client['name'] ?? 'N/A'),
            _buildInfoRow('Email', client['email'] ?? 'N/A'),
            _buildInfoRow('Phone', client['phone'] ?? 'N/A'),
          ] else ...[
            _buildInfoRow('Client ID', widget.booking.clientId),
            _buildInfoRow('Contact', 'Contact information not available'),
          ],
        ],
      ),
    );
  }

  Widget _buildEventSection(ThemeData theme, ColorScheme colorScheme) {
    return _buildSection(
      theme: theme,
      colorScheme: colorScheme,
      title: 'Event Details',
      icon: Icons.event,
      child: Column(
        children: [
          _buildInfoRow('Event Type', widget.booking.eventType),
          _buildInfoRow('Date', widget.booking.formattedEventDate),
          _buildInfoRow('Time', widget.booking.eventTime),
          _buildInfoRow('Location', widget.booking.eventLocation),
          _buildInfoRow('Service Type', _getServiceTypeName(widget.booking.serviceType)),
        ],
      ),
    );
  }

  Widget _buildPackageSection(ThemeData theme, ColorScheme colorScheme) {
    // Use packageSnapshot if available, otherwise fallback to package
    final package = widget.booking.packageSnapshot ?? widget.booking.package;

    String getField(String key) {
      if (package == null) return 'N/A';
      if (package is Map) {
        return (package as Map)[key]?.toString() ?? 'N/A';
      }
      if (package.runtimeType.toString().contains('ServicePackage')) {
        try {
          final value = (package as dynamic).toJson()[key];
          return value?.toString() ?? 'N/A';
        } catch (_) {
          return 'N/A';
        }
      }
      return 'N/A';
    }

    List<String> getFeatures() {
      if (package == null) return [];
      if (package is Map) {
        final features = (package as Map)['features'];
        if (features is List) {
          return features.map((e) => e.toString()).toList();
        }
        return [];
      }
      if (package.runtimeType.toString().contains('ServicePackage')) {
        try {
          final features = (package as dynamic).features;
          if (features is List<String>) return features;
          if (features is List) return features.map((e) => e.toString()).toList();
          return [];
        } catch (_) {
          return [];
        }
      }
      return [];
    }

    return _buildSection(
      theme: theme,
      colorScheme: colorScheme,
      title: 'Package Details',
      icon: Icons.inventory_2,
      child: Column(
        children: [
          if (package != null) ...[
            _buildInfoRow('Package Name', getField('name')),
            _buildInfoRow('Base Price', '\$${getField('basePrice')}'),
            _buildInfoRow('Duration', '${getField('durationHours')} hours'),
            if (getFeatures().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Features:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              ...getFeatures().map((feature) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 2),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ] else ...[
            _buildInfoRow('Package ID', widget.booking.packageId),
            _buildInfoRow('Package', 'Package details not available'),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentSection(ThemeData theme, ColorScheme colorScheme) {
    return _buildSection(
      theme: theme,
      colorScheme: colorScheme,
      title: 'Payment Information',
      icon: Icons.payment,
      child: Column(
        children: [
          _buildInfoRow('Status', _getPaymentStatusText(widget.booking.paymentStatus)),
          _buildInfoRow('Amount', widget.booking.formattedAmount),
          if (widget.booking.hasPriceChanged) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    size: 16,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Price modified from original package',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineSection(ThemeData theme, ColorScheme colorScheme) {
    return _buildSection(
      theme: theme,
      colorScheme: colorScheme,
      title: 'Booking Timeline',
      icon: Icons.timeline,
      child: Column(
        children: [
          _buildTimelineItem(
            theme,
            colorScheme,
            'Booking Created',
            widget.booking.createdAt,
            Icons.add_circle,
            Colors.green,
            true,
          ),
          _buildTimelineItem(
            theme,
            colorScheme,
            'Last Updated',
            widget.booking.updatedAt,
            Icons.update,
            Colors.blue,
            true,
          ),
          if (widget.booking.status == BookingStatus.confirmed)
            _buildTimelineItem(
              theme,
              colorScheme,
              'Booking Confirmed',
              widget.booking.updatedAt,
              Icons.check_circle,
              Colors.green,
              true,
            ),
          if (widget.booking.status == BookingStatus.inProgress)
            _buildTimelineItem(
              theme,
              colorScheme,
              'Service Started',
              widget.booking.updatedAt,
              Icons.play_circle,
              Colors.orange,
              true,
            ),
          if (widget.booking.status == BookingStatus.completed)
            _buildTimelineItem(
              theme,
              colorScheme,
              'Service Completed',
              widget.booking.updatedAt,
              Icons.done_all,
              Colors.green,
              true,
            ),
          if (widget.booking.status == BookingStatus.cancelled)
            _buildTimelineItem(
              theme,
              colorScheme,
              'Booking Cancelled',
              widget.booking.updatedAt,
              Icons.cancel,
              Colors.red,
              true,
            ),
          _buildTimelineItem(
            theme,
            colorScheme,
            'Event Date',
            widget.booking.eventDate,
            Icons.event,
            widget.booking.isUpcoming ? Colors.blue : Colors.grey,
            widget.booking.isUpcoming,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialRequestsSection(ThemeData theme, ColorScheme colorScheme) {
    return _buildSection(
      theme: theme,
      colorScheme: colorScheme,
      title: 'Special Requests',
      icon: Icons.note,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          widget.booking.specialRequests!,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
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
              Icon(
                icon,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    ThemeData theme,
    ColorScheme colorScheme,
    String title,
    DateTime date,
    IconData icon,
    Color color,
    bool isCompleted,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCompleted ? color : colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isCompleted ? Colors.white : colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  _formatDateTime(date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
    final isProvider = widget.provider.userType != UserType.client;
    final status = widget.booking.status;
    List<Widget> actions = [];

    if (isProvider) {
      if (status == BookingStatus.pending) {
        actions = [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _isUpdatingStatus ? null : () => _updateBookingStatus(BookingStatus.rejected),
              icon: const Icon(Icons.close),
              label: const Text('Reject'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isUpdatingStatus ? null : () => _updateBookingStatus(BookingStatus.confirmed),
              icon: const Icon(Icons.check),
              label: const Text('Accept'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ];
      } else if (status == BookingStatus.confirmed) {
        actions = [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isUpdatingStatus ? null : () => _updateBookingStatus(BookingStatus.inProgress),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _isUpdatingStatus ? null : () => _updateBookingStatus(BookingStatus.cancelled),
              icon: const Icon(Icons.cancel),
              label: const Text('Cancel'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ];
      } else if (status == BookingStatus.inProgress) {
        actions = [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isUpdatingStatus ? null : () => _updateBookingStatus(BookingStatus.completed),
              icon: const Icon(Icons.check_circle),
              label: const Text('Complete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ];
      }
    } else {
      // Client actions
      if (status == BookingStatus.pending || status == BookingStatus.confirmed) {
        actions = [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _isUpdatingStatus ? null : () => _updateBookingStatus(BookingStatus.cancelled),
              icon: const Icon(Icons.cancel),
              label: const Text('Cancel'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ];
      }
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: actions,
        ),
      ),
    );
  }

  void _showBookingMenu(BuildContext context) {
    final isClient = widget.provider.userType == UserType.client;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isClient) ...[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Booking'),
                onTap: () {
                  Navigator.pop(context);
                  _editBooking();
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Reschedule'),
                onTap: () {
                  Navigator.pop(context);
                  _rescheduleBooking();
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Generate Invoice'),
              onTap: () {
                Navigator.pop(context);
                _generateInvoice();
              },
            ),
            if (widget.booking.status != BookingStatus.cancelled)
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text('Cancel Booking', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _cancelBooking();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateBookingStatus(BookingStatus newStatus) async {
    setState(() {
      _isUpdatingStatus = true;
    });

    try {
      // Call the provider to update the booking status
      await ref.read(bookingsProvider.notifier).updateBookingStatus(widget.booking.id, newStatus.name);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking status updated to ${newStatus.name.toUpperCase()}'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update booking status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingStatus = false;
        });
      }
    }
  }

  void _editBooking() {
    // TODO: Navigate to booking edit form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to booking edit form')),
    );
  }

  void _rescheduleBooking() {
    // TODO: Show date/time picker for rescheduling
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Show reschedule dialog')),
    );
  }

  void _generateInvoice() {
    // TODO: Generate and show invoice
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generate invoice')),
    );
  }

  void _cancelBooking() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateBookingStatus(BookingStatus.cancelled);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.blue;
      case BookingStatus.inProgress:
        return Colors.purple;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.rejected:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Icons.schedule;
      case BookingStatus.confirmed:
        return Icons.check_circle;
      case BookingStatus.inProgress:
        return Icons.play_circle;
      case BookingStatus.completed:
        return Icons.done_all;
      case BookingStatus.cancelled:
        return Icons.cancel;
      case BookingStatus.rejected:
        return Icons.close;
    }
  }

  String _getStatusDescription(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Awaiting your confirmation';
      case BookingStatus.confirmed:
        return 'Booking confirmed and scheduled';
      case BookingStatus.inProgress:
        return 'Service is currently being provided';
      case BookingStatus.completed:
        return 'Service has been completed';
      case BookingStatus.cancelled:
        return 'Booking has been cancelled';
      case BookingStatus.rejected:
        return 'Booking has been rejected';
    }
  }

  String _getPaymentStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.partiallyPaid:
        return 'Partially Paid';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }

  String _getServiceTypeName(ServiceType type) {
    switch (type) {
      case ServiceType.photography:
        return 'Photography';
      case ServiceType.makeup:
        return 'Makeup Artist';
      case ServiceType.decoration:
        return 'Decoration';
      case ServiceType.venue:
        return 'Venue';
      case ServiceType.catering:
        return 'Catering';
      case ServiceType.music:
        return 'Music';
      case ServiceType.planning:
        return 'Event Planning';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
} 