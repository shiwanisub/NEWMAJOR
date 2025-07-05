import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:swornim/pages/providers/service_providers/models/makeup_artist.dart';
import 'package:swornim/pages/models/review.dart';
import 'package:swornim/pages/models/user/user.dart';
import 'package:swornim/pages/providers/bookings/package_manager.dart';
import 'package:swornim/pages/providers/service_providers/service_provider_factory.dart';
import 'package:swornim/pages/providers/service_providers/service_provider_manager.dart';
import 'package:swornim/pages/models/bookings/service_package.dart';
import 'package:swornim/pages/providers/bookings/bookings.dart';
import 'package:swornim/pages/providers/auth/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:swornim/pages/models/bookings/booking.dart';

// Provider to fetch a single makeup artist by their ID
final makeupArtistDetailProvider = FutureProvider.family<MakeupArtist, String>((ref, makeupArtistId) async {
  final manager = ref.read(serviceProviderManagerProvider);
  final result = await manager.getServiceProvider(ServiceProviderType.makeupArtist, makeupArtistId);
  if (result.isError || result.data == null) throw Exception(result.error ?? 'Makeup Artist not found');
  return result.data as MakeupArtist;
});

// Re-using the same provider for packages as the photographer page
final packagesForMakeupArtistProvider = FutureProvider.family<List<ServicePackage>, String>((ref, serviceProviderId) async {
  final manager = ref.read(packageManagerProvider);
  return await manager.fetchPackagesForProvider(serviceProviderId);
});

// Add userDetailsProvider for fetching real user info
final userDetailsProvider = FutureProvider.family<User, String>((ref, userId) async {
  final authHeaders = ref.read(authProvider.notifier).getAuthHeaders();
  final response = await http.get(
    Uri.parse('http://10.0.2.2:9009/api/v1/users/$userId'),
    headers: authHeaders,
  );
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return User.fromJson(jsonData['data'] ?? jsonData);
  } else {
    throw Exception('Failed to load user');
  }
});

class MakeupArtistDetailPage extends ConsumerStatefulWidget {
  final String makeupArtistId;
  
  const MakeupArtistDetailPage({
    super.key,
    required this.makeupArtistId,
  });

  @override
  ConsumerState<MakeupArtistDetailPage> createState() => _MakeupArtistDetailPageState();
}

class _MakeupArtistDetailPageState extends ConsumerState<MakeupArtistDetailPage>
    with TickerProviderStateMixin {
  
  // Animation controllers
  late AnimationController _mainAnimationController;
  late AnimationController _fabAnimationController;
  late AnimationController _tabAnimationController;
  
  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  // UI State
  bool _isFavorite = false;
  bool _isBookingExpanded = false;
  int _selectedTabIndex = 0;
  int _selectedImageIndex = 0;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTimeSlot = '';
  String? _selectedPackageId;
  String _selectedPackageName = '';
  double? _selectedPackagePrice;
  
  // Page controller for image gallery
  late PageController _imagePageController;
  
  // Tab controller
  late TabController _tabController;
  
  // Sample data (replace with actual data from your models)
  final List<String> _portfolioImages = [
    'https://images.unsplash.com/photo-1606216794074-735e91aa2c92?w=800',
    'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800',
    'https://images.unsplash.com/photo-1519741497674-611481863552?w=800',
    'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=800',
    'https://images.unsplash.com/photo-1465495976277-4387d4b0e4a6?w=800',
  ];
  
  final List<String> _timeSlots = [
    '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
    '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM'
  ];
  
  final List<Map<String, dynamic>> _packages = [
    {
      'name': 'Basic Package',
      'price': 15000,
      'duration': '2 hours',
      'photos': '50+ edited photos',
      'features': ['Digital gallery', 'Basic editing', 'Online delivery'],
    },
    {
      'name': 'Premium Package',
      'price': 25000,
      'duration': '4 hours',
      'photos': '100+ edited photos',
      'features': ['Digital gallery', 'Advanced editing', 'Print release', 'USB delivery'],
      'popular': true,
    },
    {
      'name': 'Deluxe Package',
      'price': 40000,
      'duration': '8 hours',
      'photos': '200+ edited photos',
      'features': ['Digital gallery', 'Premium editing', 'Print release', 'USB + online delivery', 'Second photographer'],
    },
  ];
  
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Sita Sharma',
      'rating': 5.0,
      'date': '2 weeks ago',
      'comment': 'Absolutely amazing work! The photos turned out better than I imagined. Professional and friendly service.',
      'images': ['https://images.unsplash.com/photo-1494790108755-2616c27e208e?w=100'],
    },
    {
      'name': 'Ram Thapa',
      'rating': 5.0,
      'date': '1 month ago',
      'comment': 'Perfect for our wedding! Captured every precious moment beautifully. Highly recommended!',
      'images': [],
    },
    {
      'name': 'Maya Gurung',
      'rating': 4.0,
      'date': '2 months ago',
      'comment': 'Great portfolio session. Very professional and made me feel comfortable throughout the shoot.',
      'images': ['https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=100'],
    },
  ];
  
  String _eventLocation = '';
  String _eventType = '';
  String _specialRequests = '';
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupControllers();
    _mainAnimationController.forward();
  }

  void _setupAnimations() {
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _tabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainAnimationController, curve: Curves.easeOutCubic),
    );
    
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _mainAnimationController, curve: Curves.easeOutCubic),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _mainAnimationController, curve: Curves.elasticOut),
    );
  }

  void _setupControllers() {
    _imagePageController = PageController();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_selectedTabIndex != _tabController.index) {
        setState(() => _selectedTabIndex = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _fabAnimationController.dispose();
    _tabAnimationController.dispose();
    _imagePageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final makeupArtistAsync = ref.watch(makeupArtistDetailProvider(widget.makeupArtistId));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: makeupArtistAsync.when(
        data: (makeupArtist) {
          // Fetch packages once we have the artist's userId
          final packagesAsync = ref.watch(packagesForMakeupArtistProvider(makeupArtist.userId));
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildHeroSection(theme, makeupArtist),
                _buildQuickInfoSection(theme, makeupArtist),
                _buildTabSection(theme),
                _buildCurrentTabContent(theme, makeupArtist, packagesAsync),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: _buildFloatingActionButtons(theme),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: SafeArea(
          child: TabBar(
            controller: _tabController,
            indicatorColor: theme.colorScheme.primary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
            labelStyle: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: 'About'),
              Tab(text: 'Services'),
              Tab(text: 'Reviews'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(ThemeData theme, MakeupArtist makeupArtist) {
    return SliverAppBar(
      expandedHeight: 400,
      floating: false,
      pinned: true,
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: () {
              // Share functionality
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image gallery
            PageView.builder(
              controller: _imagePageController,
              itemCount: makeupArtist.portfolio.isEmpty ? 1 : makeupArtist.portfolio.length,
              onPageChanged: (index) {
                setState(() {
                  _selectedImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                if (makeupArtist.portfolio.isEmpty) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.palette_rounded, color: Colors.white, size: 80),
                    ),
                  );
                }
                
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(makeupArtist.portfolio[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
            
            // Gradient overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black26,
                    Colors.black54,
                  ],
                ),
              ),
            ),
            
            // Image indicators
            if (makeupArtist.portfolio.isNotEmpty)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(makeupArtist.portfolio.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _selectedImageIndex == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _selectedImageIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            
            // Bottom info overlay
            Positioned(
              bottom: 60,
              left: 20,
              right: 20,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              makeupArtist.businessName,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (makeupArtist.isAvailable)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.verified_rounded,
                                color: theme.colorScheme.primary,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < (makeupArtist.rating?.floor() ?? 0)
                                  ? Icons.star_rounded
                                  : index < (makeupArtist.rating ?? 0)
                                      ? Icons.star_half_rounded
                                      : Icons.star_outline_rounded,
                              color: Colors.amber[600],
                              size: 18,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            (makeupArtist.rating != null && makeupArtist.totalReviews > 0)
                                ? '${makeupArtist.rating.toStringAsFixed(1)} (${makeupArtist.totalReviews} reviews)'
                                : 'No reviews yet',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfoSection(ThemeData theme, MakeupArtist makeupArtist) {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _mainAnimationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value * 0.5),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Status and location
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: makeupArtist.isAvailable
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: makeupArtist.isAvailable
                                      ? Colors.green
                                      : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                makeupArtist.isAvailable ? 'Available' : 'Busy',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: makeupArtist.isAvailable
                                      ? Colors.green[700]
                                      : Colors.red[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              makeupArtist.location?.name ?? 'Location not specified',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Quick stats
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Experience',
                            '${makeupArtist.experienceYears} years',
                            Icons.work_history_rounded,
                            theme,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Session Rate',
                            'NPR ${makeupArtist.sessionRate.toStringAsFixed(0)}',
                            Icons.attach_money_rounded,
                            theme,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Hair Services',
                            makeupArtist.offersHairServices ? 'Yes' : 'No',
                            Icons.face_retouching_natural,
                            theme,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Specializations
                    if (makeupArtist.specializations.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Specializations',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: makeupArtist.specializations.map((spec) {
                          final capSpec = spec.isNotEmpty ? spec[0].toUpperCase() + spec.substring(1) : spec;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary.withOpacity(0.1),
                                  theme.colorScheme.secondary.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              capSpec,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection(ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
          labelStyle: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'About'),
            Tab(text: 'Services'),
            Tab(text: 'Reviews'),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTabContent(ThemeData theme, MakeupArtist makeupArtist, AsyncValue<List<ServicePackage>> packagesAsync) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildAboutContent(theme, makeupArtist);
      case 1:
        return _buildServicesContent(theme, makeupArtist, packagesAsync);
      case 2:
        return _buildReviewsContent(theme, makeupArtist);
      default:
        return _buildAboutContent(theme, makeupArtist);
    }
  }

  Widget _buildAboutContent(ThemeData theme, MakeupArtist makeupArtist) {
    final userAsync = ref.watch(userDetailsProvider(makeupArtist.userId));
    return userAsync.when(
      data: (user) => SliverToBoxAdapter(
        child: Container(
          key: const ValueKey('about'),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About ${makeupArtist.businessName}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                makeupArtist.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoSection(
                'Equipment & Gear',
                Icons.brush_rounded,
                [
                  'Professional makeup kit',
                  'High-quality brushes and tools',
                  'Studio lighting',
                  'Airbrush machine',
                ],
                theme,
              ),
              const SizedBox(height: 20),
              _buildInfoSection(
                'Services Offered',
                Icons.palette_rounded,
                makeupArtist.specializations,
                theme,
              ),
              const SizedBox(height: 20),
              _buildContactInfo(theme, user),
            ],
          ),
        ),
      ),
      loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
      error: (e, _) => SliverToBoxAdapter(child: Text('Error loading contact info: $e')),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, List<String> items, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildContactInfo(ThemeData theme, User user) {
    final phone = user.phone.isNotEmpty ? user.phone : '+977 98XXXXXXXX';
    final email = user.email.isNotEmpty ? user.email : 'contact@makeupartist.com';
    final website = 'www.makeupartist.com'; // Placeholder, update if available
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(Icons.phone_rounded, phone, theme),
          const SizedBox(height: 12),
          _buildContactItem(Icons.email_rounded, email, theme),
          const SizedBox(height: 12),
          _buildContactItem(Icons.language_rounded, website, theme),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text, ThemeData theme) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesContent(ThemeData theme, MakeupArtist makeupArtist, AsyncValue<List<ServicePackage>> packagesAsync) {
    return SliverToBoxAdapter(
      child: Container(
        key: const ValueKey('packages'),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: packagesAsync.when(
          data: (pkgs) => pkgs.isEmpty
              ? const Text('No packages found.')
              : Column(
                  children: pkgs.map((pkg) => _buildServicePackage(
                    pkg.name,
                    pkg.basePrice,
                    '${pkg.durationHours} hours',
                    pkg.features,
                    theme,
                  )).toList(),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error loading packages: $e'),
        ),
      ),
    );
  }
  
  Widget _buildReviewsContent(ThemeData theme, MakeupArtist makeupArtist) {
    if (makeupArtist.reviews.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.rate_review_outlined, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text('No reviews yet.'),
            ],
          ),
        ),
      );
    }
    
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final review = makeupArtist.reviews[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 20),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          // You might want to add user images to your review model
                          child: Text('A'), // Placeholder
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Anonymous", style: theme.textTheme.titleMedium),
                              Text(
                                // Format the date nicely
                                'Posted on ${review.createdAt.toLocal().toString().split(' ')[0]}',
                                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(review.rating.toString(), style: theme.textTheme.titleMedium),
                            Icon(Icons.star, color: Colors.amber, size: 18),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(review.comment, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            );
          },
          childCount: makeupArtist.reviews.length,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons(ThemeData theme) {
    return FloatingActionButton.extended(
      heroTag: 'book',
      onPressed: () => _showBookingDialog(theme),
      backgroundColor: theme.colorScheme.primary,
      icon: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 20),
      label: const Text(
        'Book Now',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  void _showBookingDialog(ThemeData theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final makeupArtistAsync = ref.watch(makeupArtistDetailProvider(widget.makeupArtistId));
          final makeupArtist = makeupArtistAsync.asData?.value;
          if (makeupArtist == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.85,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Text(
                            'Book Session',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBookingSection(
                              'Select Date',
                              Icons.calendar_today_rounded,
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: theme.dividerColor),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: _selectedDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                    );
                                    if (date != null) {
                                      setModalState(() => _selectedDate = date);
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_rounded,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              theme,
                            ),
                            const SizedBox(height: 24),
                            _buildBookingSection(
                              'Select Time',
                              Icons.access_time_rounded,
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _timeSlots.map((time) {
                                  final isSelected = _selectedTimeSlot == time;
                                  return GestureDetector(
                                    onTap: () => setModalState(() => _selectedTimeSlot = time),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : theme.scaffoldBackgroundColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? theme.colorScheme.primary
                                              : theme.dividerColor,
                                        ),
                                      ),
                                      child: Text(
                                        time,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: isSelected
                                              ? Colors.white
                                              : theme.colorScheme.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              theme,
                            ),
                            const SizedBox(height: 24),
                            _buildBookingSection(
                              'Event Location',
                              Icons.location_on_rounded,
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter event location',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                onChanged: (val) => setModalState(() => _eventLocation = val),
                              ),
                              theme,
                            ),
                            const SizedBox(height: 24),
                            _buildBookingSection(
                              'Event Type',
                              Icons.event_rounded,
                              DropdownButtonFormField<String>(
                                value: _eventType.isNotEmpty ? _eventType : null,
                                items: ['Wedding', 'Party', 'Editorial', 'Fashion', 'Other'].map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                )).toList(),
                                onChanged: (val) => setModalState(() => _eventType = val ?? ''),
                                decoration: InputDecoration(
                                  hintText: 'Select event type',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                              ),
                              theme,
                            ),
                            const SizedBox(height: 24),
                            _buildBookingSection(
                              'Special Requests (Optional)',
                              Icons.notes_rounded,
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Any special requests?',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                onChanged: (val) => setModalState(() => _specialRequests = val),
                                maxLines: 2,
                              ),
                              theme,
                            ),
                            const SizedBox(height: 24),
                            Consumer(
                              builder: (context, ref, _) {
                                final packagesAsync = ref.watch(packagesForMakeupArtistProvider(makeupArtist.userId));
                                return packagesAsync.when(
                                  data: (pkgs) => _buildBookingSection(
                                    'Select Package',
                                    Icons.photo_library_rounded,
                                    Column(
                                      children: pkgs.map((package) {
                                        final isSelected = _selectedPackageId == package.id;
                                        return Container(
                                          margin: const EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).scaffoldBackgroundColor,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
                                            ),
                                          ),
                                          child: RadioListTile<String>(
                                            value: package.id,
                                            groupValue: _selectedPackageId,
                                            onChanged: (value) {
                                              setModalState(() {
                                                _selectedPackageId = value;
                                                _selectedPackageName = package.name;
                                                _selectedPackagePrice = package.basePrice;
                                              });
                                            },
                                            title: Text(package.name),
                                            subtitle: Text('NPR ${package.basePrice} • ${package.durationHours} hours'),
                                            activeColor: theme.colorScheme.primary,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    theme,
                                  ),
                                  loading: () => const Center(child: CircularProgressIndicator()),
                                  error: (e, _) => Text('Error loading packages: $e'),
                                );
                              },
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _selectedTimeSlot.isNotEmpty && _selectedPackageId != null && _eventLocation.isNotEmpty && _eventType.isNotEmpty
                              ? () {
                                  Navigator.pop(context);
                                  _handleBookingSubmission(ref, theme);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Confirm Booking',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleBookingSubmission(WidgetRef ref, ThemeData theme) async {
    try {
      final currentUser = ref.read(authProvider).user;
      final makeupArtist = ref.read(makeupArtistDetailProvider(widget.makeupArtistId)).asData?.value;
      final packagesAsync = ref.read(packagesForMakeupArtistProvider(makeupArtist?.userId ?? ''));
      final selectedPackage = () {
        final pkgs = packagesAsync.asData?.value;
        if (pkgs == null) return null;
        try {
          return pkgs.firstWhere((pkg) => pkg.id == _selectedPackageId);
        } catch (_) {
          return null;
        }
      }();
      if (currentUser == null || makeupArtist == null || selectedPackage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Missing booking information.')),
        );
        return;
      }
      final bookingRequest = BookingRequest(
        serviceProviderId: makeupArtist.userId,
        packageId: selectedPackage.id,
        eventDate: _selectedDate,
        eventTime: _selectedTimeSlot,
        eventLocation: _eventLocation,
        eventType: _eventType,
        totalAmount: selectedPackage.basePrice,
        specialRequests: _specialRequests.isNotEmpty ? _specialRequests : null,
        serviceType: ServiceType.makeup,
      );
      final bookingManager = ref.read(bookingManagerProvider);
      final isServerReachable = await bookingManager.testServerConnection();
      if (!isServerReachable) {
        throw Exception('Cannot connect to server. Please check if the backend is running and accessible.');
      }
      await bookingManager.createBooking(bookingRequest);
      ref.invalidate(bookingsProvider);
      _showBookingConfirmation(theme);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create booking: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showBookingConfirmation(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Booking Confirmed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your booking has been confirmed.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking Details:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                  Text('Time: $_selectedTimeSlot'),
                  Text('Package: $_selectedPackageName'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSection(String title, IconData icon, Widget content, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildServicePackage(String name, double price, String subtitle, List<String> features, ThemeData theme, {bool isPopular = false}) {
    final isSelected = _selectedPackageId == name;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected 
              ? theme.colorScheme.primary 
              : isPopular 
                  ? theme.colorScheme.secondary.withOpacity(0.3)
                  : theme.dividerColor,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.1)
                : Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => setState(() => _selectedPackageId = name),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                subtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (isPopular)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[700],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('POPULAR', style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                )),
                              ),
                            if (isPopular) const SizedBox(height: 8),
                            Text(
                              'NPR ${price.toStringAsFixed(0)}',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Features list
                    ...features.map<Widget>((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: theme.colorScheme.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                ),
              ),
              
              // Selection indicator
              if (isSelected)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}