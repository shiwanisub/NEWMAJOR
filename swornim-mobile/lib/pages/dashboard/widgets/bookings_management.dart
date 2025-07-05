import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swornim/pages/models/user/user.dart';
import 'package:swornim/pages/models/bookings/booking.dart';
import 'package:swornim/pages/providers/bookings/bookings_provider.dart';
import 'package:swornim/pages/widgets/common/booking_card.dart';

class BookingsManagement extends ConsumerStatefulWidget {
  final User provider;
  
  const BookingsManagement({required this.provider, Key? key}) : super(key: key);

  @override
  ConsumerState<BookingsManagement> createState() => _BookingsManagementState();
}

class _BookingsManagementState extends ConsumerState<BookingsManagement> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  DateTimeRange? _dateRange;
  BookingStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
    final bookingsState = ref.watch(bookingsProvider);

    return Column(
      children: [
        // Search and Filter Bar
        _buildSearchAndFilterBar(theme, colorScheme),
        
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withOpacity(0.1),
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Confirmed'),
              Tab(text: 'In Progress'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        
        // Bookings List
        Expanded(
          child: bookingsState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : bookingsState.error != null
                  ? _buildErrorState(theme, colorScheme, bookingsState.error!)
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildBookingsList(_getFilteredBookings(bookingsState.bookings, null)),
                        _buildBookingsList(_getFilteredBookings(bookingsState.bookings, BookingStatus.pending)),
                        _buildBookingsList(_getFilteredBookings(bookingsState.bookings, BookingStatus.confirmed)),
                        _buildBookingsList(_getFilteredBookings(bookingsState.bookings, BookingStatus.inProgress)),
                        _buildBookingsList(_getFilteredBookings(bookingsState.bookings, BookingStatus.completed)),
                      ],
                    ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search by client name or event type...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Filter Row
          Row(
            children: [
              // Date Range Filter
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _selectDateRange,
                  icon: const Icon(Icons.date_range),
                  label: Text(_dateRange == null 
                      ? 'Date Range' 
                      : '${_formatDate(_dateRange!.start)} - ${_formatDate(_dateRange!.end)}'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              // Status Filter
              Expanded(
                child: PopupMenuButton<BookingStatus?>(
                  onSelected: (status) {
                    setState(() {
                      _selectedStatus = status;
                    });
                  },
                  child: OutlinedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.filter_list),
                    label: Text(_selectedStatus?.name.toUpperCase() ?? 'Status'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: null,
                      child: Text('All Status'),
                    ),
                    ...BookingStatus.values.map((status) => PopupMenuItem(
                      value: status,
                      child: Text(status.name.toUpperCase()),
                    )),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Clear Filters
              if (_dateRange != null || _selectedStatus != null)
                IconButton(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear_all),
                  tooltip: 'Clear filters',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings) {
    if (bookings.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: BookingCard(
            booking: booking,
            currentUser: widget.provider,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No bookings found',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search criteria',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, ColorScheme colorScheme, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading bookings',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(bookingsProvider.notifier).fetchBookings();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  List<Booking> _getFilteredBookings(List<Booking> bookings, BookingStatus? tabStatus) {
    List<Booking> filtered = bookings;

    // Apply tab filter
    if (tabStatus != null) {
      filtered = filtered.where((booking) => booking.status == tabStatus).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((booking) {
        final query = _searchQuery.toLowerCase();
        return booking.eventType.toLowerCase().contains(query) ||
               (booking.client?['name']?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply date range filter
    if (_dateRange != null) {
      filtered = filtered.where((booking) {
        return booking.eventDate.isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
               booking.eventDate.isBefore(_dateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    // Apply status filter
    if (_selectedStatus != null) {
      filtered = filtered.where((booking) => booking.status == _selectedStatus).toList();
    }

    // Sort by event date (most recent first)
    filtered.sort((a, b) => b.eventDate.compareTo(a.eventDate));

    return filtered;
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _dateRange,
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _dateRange = null;
      _selectedStatus = null;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 