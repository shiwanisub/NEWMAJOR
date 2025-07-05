// widgets/client/dashboard/service_grid.dart
import 'package:flutter/material.dart';
import 'package:swornim/pages/service_providers/venues/venuelistpage.dart';

class ServiceGrid extends StatelessWidget {
  final Function(String, BuildContext) onServiceTap;

  const ServiceGrid({
    super.key,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Enhanced Services section header
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our Services',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Professional services for your special events',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    // Handle view all services
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_forward_rounded, 
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  label: Text(
                    'View All',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Services grid with 2 cards per row
        Column(
          children: [
            // First row
            Row(
              children: [
                Expanded(
                  child: _buildCompactServiceCard(
                    Icons.location_city_rounded,
                    'Book Venue',
                    'Find perfect venues',
                    const Color(0xFF6366F1), // Modern indigo
                    context,
                    0,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCompactServiceCard(
                    Icons.camera_alt_rounded,
                    'Photographers',
                    'Professional photography',
                    const Color(0xFF8B5CF6), // Modern purple
                    context,
                    1,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Second row
            Row(
              children: [
                Expanded(
                  child: _buildCompactServiceCard(
                    Icons.brush_rounded,
                    'Makeup Artists',
                    'Beauty professionals',
                    const Color(0xFFEC4899), // Modern pink
                    context,
                    2,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCompactServiceCard(
                    Icons.auto_awesome_rounded,
                    'Decorators',
                    'Event decoration',
                    const Color(0xFFF59E0B), // Modern amber
                    context,
                    3,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Third row (single card centered)
            Row(
              children: [
                Expanded(
                  child: _buildCompactServiceCard(
                    Icons.ramen_dining_rounded,
                    'Caterers',
                    'Food & catering',
                    const Color(0xFF10B981), // Modern emerald
                    context,
                    4,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Container()), // Empty space for alignment
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompactServiceCard(
    IconData icon,
    String title,
    String subtitle,
    Color accentColor,
    BuildContext context,
    int index,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 15 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          onServiceTap(title, context);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.06),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.1 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onServiceTap(title, context),
              borderRadius: BorderRadius.circular(16),
              splashColor: accentColor.withOpacity(0.08),
              highlightColor: accentColor.withOpacity(0.04),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark 
                    ? colorScheme.surface.withOpacity(0.9)
                    : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: accentColor.withOpacity(0.12),
                    width: 1,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentColor.withOpacity(0.04),
                      accentColor.withOpacity(0.01),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Compact icon container
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        size: 24,
                        color: accentColor,
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                              letterSpacing: -0.2,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 4),
                          
                          Text(
                            subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11,
                              letterSpacing: 0.1,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    // Small arrow indicator
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: accentColor.withOpacity(0.6),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}