import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swornim/pages/models/user/user.dart';
import 'package:swornim/pages/models/bookings/service_package.dart';
import 'package:swornim/pages/models/bookings/booking.dart';
import 'package:swornim/pages/providers/bookings/bookings.dart';
import 'package:swornim/pages/dashboard/widgets/package_form_dialog.dart';
import 'package:swornim/pages/models/user/user_types.dart';
import 'package:swornim/pages/providers/auth/auth_provider.dart';

class PackageManagement extends ConsumerStatefulWidget {
  final User provider;
  
  const PackageManagement({required this.provider, Key? key}) : super(key: key);

  @override
  ConsumerState<PackageManagement> createState() => _PackageManagementState();
}

class _PackageManagementState extends ConsumerState<PackageManagement> {
  String _searchQuery = '';
  bool _showActiveOnly = true;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _basePriceController = TextEditingController();
  final _durationController = TextEditingController();
  final _featuresController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final packagesAsync = ref.watch(packagesProvider(widget.provider.id));

    return Column(
      children: [
        // Header with Search and Actions
        _buildHeader(theme, colorScheme),
        
        // Packages List
        Expanded(
          child: packagesAsync.when(
            data: (packages) => _buildPackagesList(packages, theme, colorScheme),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(theme, colorScheme, error.toString()),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
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
          // Search and Filter Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search packages...',
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
              ),
              const SizedBox(width: 12),
              FilterChip(
                selected: _showActiveOnly,
                onSelected: (selected) {
                  setState(() {
                    _showActiveOnly = selected;
                  });
                },
                label: const Text('Active Only'),
                avatar: Icon(
                  Icons.check_circle,
                  size: 16,
                  color: _showActiveOnly ? Colors.white : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _createNewPackage(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Package'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesList(List<ServicePackage> packages, ThemeData theme, ColorScheme colorScheme) {
    final filteredPackages = _getFilteredPackages(packages);
    
    if (filteredPackages.isEmpty) {
      return _buildEmptyState(theme, colorScheme);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredPackages.length,
      itemBuilder: (context, index) {
        final package = filteredPackages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildPackageCard(package, theme, colorScheme),
        );
      },
    );
  }

  Widget _buildPackageCard(ServicePackage package, ThemeData theme, ColorScheme colorScheme) {
    return Container(
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
        children: [
          // Package Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Package Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getServiceTypeIcon(package.serviceType),
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Package Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              package.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: package.isActive 
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              package.isActive ? 'ACTIVE' : 'INACTIVE',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: package.isActive ? Colors.green : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        package.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      package.formattedPrice,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    Text(
                      '${package.durationHours}h',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Package Features
          if (package.features.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: package.features.take(3).map((feature) => Chip(
                  label: Text(
                    feature,
                    style: theme.textTheme.bodySmall,
                  ),
                  backgroundColor: colorScheme.surfaceVariant.withOpacity(0.3),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                )).toList(),
              ),
            ),
            if (package.features.length > 3)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '+${package.features.length - 3} more features',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editPackage(context, package),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _duplicatePackage(context, package),
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Duplicate'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _togglePackageStatus(package),
                    icon: Icon(
                      package.isActive ? Icons.pause : Icons.play_arrow,
                      size: 16,
                    ),
                    label: Text(package.isActive ? 'Pause' : 'Activate'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showPackageMenu(context, package),
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'More options',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No packages found',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first service package to start receiving bookings',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _createNewPackage(context),
            icon: const Icon(Icons.add),
            label: const Text('Create Package'),
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
            'Error loading packages',
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
              ref.invalidate(packagesProvider(widget.provider.id));
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  List<ServicePackage> _getFilteredPackages(List<ServicePackage> packages) {
    List<ServicePackage> filtered = packages;

    // Apply active filter
    if (_showActiveOnly) {
      filtered = filtered.where((package) => package.isActive).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((package) {
        final query = _searchQuery.toLowerCase();
        return package.name.toLowerCase().contains(query) ||
               package.description.toLowerCase().contains(query);
      }).toList();
    }

    // Sort by creation date (newest first)
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return filtered;
  }

  IconData _getServiceTypeIcon(ServiceType serviceType) {
    switch (serviceType) {
      case ServiceType.photography:
        return Icons.camera_alt;
      case ServiceType.makeup:
        return Icons.face;
      case ServiceType.decoration:
        return Icons.celebration;
      case ServiceType.venue:
        return Icons.location_on;
      case ServiceType.catering:
        return Icons.restaurant;
      case ServiceType.music:
        return Icons.music_note;
      case ServiceType.planning:
        return Icons.event_note;
    }
    return Icons.event; // Default fallback
  }

  void _createNewPackage(BuildContext context) async {
    final fixedServiceType = serviceTypeFromUserType(widget.provider.userType);
    try {
      print('🔐 PackageManagement: Starting package creation for provider: ${widget.provider.id}');
      print('🔐 PackageManagement: Current auth state - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
      print('🔐 PackageManagement: Current auth state - user: ${ref.read(authProvider).user?.name}');
      
      final newPackage = await showDialog<ServicePackage>(
        context: context,
        builder: (context) => PackageFormDialog(
          onSubmit: (pkg) => Navigator.of(context).pop(pkg),
          fixedServiceType: fixedServiceType,
          providerId: widget.provider.id,
        ),
      );
      
      print('🔐 PackageManagement: Dialog closed, newPackage: ${newPackage?.name}');
      
      if (newPackage != null) {
        print('🔐 PackageManagement: Package created in dialog, calling manager.createPackage');
        print('🔐 PackageManagement: Auth state before manager call - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
        
        final manager = ref.read(packageManagerProvider);
        await manager.createPackage(newPackage);
        
        print('🔐 PackageManagement: Package created successfully, invalidating provider');
        print('🔐 PackageManagement: Auth state after manager call - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
        
        // Check if widget is still mounted before continuing
        if (!mounted) {
          print('🔐 PackageManagement: Widget disposed, stopping execution');
          return;
        }
        
        // Use invalidate instead of refresh to match the working pattern
        ref.invalidate(packagesProvider(widget.provider.id));
        
        print('🔐 PackageManagement: Provider invalidated, auth state - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Package created successfully!')),
        );
        
        print('🔐 PackageManagement: Success message shown, auth state - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
      } else {
        print('🔐 PackageManagement: Dialog was cancelled, no package created');
      }
    } catch (e, st) {
      print('🔐 PackageManagement: Error creating package: $e');
      print('🔐 PackageManagement: Stack trace: $st');
      
      // Only try to access ref if widget is still mounted
      if (mounted) {
        print('🔐 PackageManagement: Auth state after error - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create package: $e')),
        );
      } else {
        print('🔐 PackageManagement: Widget disposed, cannot show error message');
      }
      debugPrint('Error creating package: $e\n$st');
    }
  }

  void _editPackage(BuildContext context, ServicePackage package) async {
    final fixedServiceType = serviceTypeFromUserType(widget.provider.userType);
    try {
      print('🔐 PackageManagement: Starting package edit for package: ${package.id}');
      print('🔐 PackageManagement: Current auth state - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
      print('🔐 PackageManagement: Current auth state - user: ${ref.read(authProvider).user?.name}');
      
      final updatedPackage = await showDialog<ServicePackage>(
        context: context,
        builder: (context) => PackageFormDialog(
          initialPackage: package,
          isEdit: true,
          onSubmit: (pkg) => Navigator.of(context).pop(pkg),
          fixedServiceType: fixedServiceType,
          providerId: widget.provider.id,
        ),
      );
      
      print('🔐 PackageManagement: Edit dialog closed, updatedPackage: ${updatedPackage?.name}');
      
      if (updatedPackage != null) {
        print('🔐 PackageManagement: Package updated in dialog, calling manager.updatePackage');
        print('🔐 PackageManagement: Auth state before manager call - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
        
        final manager = ref.read(packageManagerProvider);
        await manager.updatePackage(package.id, updatedPackage.toUpdateJson());
        
        print('🔐 PackageManagement: Package updated successfully, invalidating provider');
        print('🔐 PackageManagement: Auth state after manager call - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
        
        // Check if widget is still mounted before continuing
        if (!mounted) {
          print('🔐 PackageManagement: Widget disposed, stopping execution');
          return;
        }
        
        // Use invalidate to match the working pattern
        ref.invalidate(packagesProvider(widget.provider.id));
        
        print('🔐 PackageManagement: Provider invalidated, auth state - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Package updated successfully!')),
        );
        
        print('🔐 PackageManagement: Success message shown, auth state - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
      } else {
        print('🔐 PackageManagement: Edit dialog was cancelled, no package updated');
      }
    } catch (e, st) {
      print('🔐 PackageManagement: Error updating package: $e');
      print('🔐 PackageManagement: Stack trace: $st');
      
      // Only try to access ref if widget is still mounted
      if (mounted) {
        print('🔐 PackageManagement: Auth state after error - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update package: $e')),
        );
      } else {
        print('🔐 PackageManagement: Widget disposed, cannot show error message');
      }
      debugPrint('Error updating package: $e\n$st');
    }
  }

  void _duplicatePackage(BuildContext context, ServicePackage package) {
    // TODO: Duplicate package functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Duplicate package: ${package.name}')),
    );
  }

  void _togglePackageStatus(ServicePackage package) {
    // TODO: Toggle package active status
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Toggle status for: ${package.name}')),
    );
  }

  void _showPackageMenu(BuildContext context, ServicePackage package) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildPackageMenu(context, package),
    );
  }

  Widget _buildPackageMenu(BuildContext context, ServicePackage package) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.visibility),
            title: const Text('View Details'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Show package details
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('View Analytics'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Show package analytics
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete Package', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _confirmDeletePackage(context, package);
            },
          ),
        ],
      ),
    );
  }

  void _confirmDeletePackage(BuildContext context, ServicePackage package) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Package'),
        content: Text('Are you sure you want to delete "${package.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePackage(package);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deletePackage(ServicePackage package) async {
    try {
      print('🔐 PackageManagement: Starting package deletion for package: ${package.id}');
      print('🔐 PackageManagement: Current auth state - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
      print('🔐 PackageManagement: Current auth state - user: ${ref.read(authProvider).user?.name}');
      
      final manager = ref.read(packageManagerProvider);
      await manager.deletePackage(package.id);
      
      print('🔐 PackageManagement: Package deleted successfully, invalidating provider');
      print('🔐 PackageManagement: Auth state after manager call - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
      
      // Check if widget is still mounted before continuing
      if (!mounted) {
        print('🔐 PackageManagement: Widget disposed, stopping execution');
        return;
      }
      
      // Use invalidate to match the working pattern
      ref.invalidate(packagesProvider(widget.provider.id));
      
      print('🔐 PackageManagement: Provider invalidated, auth state - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Package deleted successfully!')),
      );
      
      print('🔐 PackageManagement: Success message shown, auth state - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
    } catch (e, st) {
      print('🔐 PackageManagement: Error deleting package: $e');
      print('🔐 PackageManagement: Stack trace: $st');
      
      // Only try to access ref if widget is still mounted
      if (mounted) {
        print('🔐 PackageManagement: Auth state after error - isLoggedIn: ${ref.read(authProvider).isLoggedIn}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete package: $e')),
        );
      } else {
        print('🔐 PackageManagement: Widget disposed, cannot show error message');
      }
      debugPrint('Error deleting package: $e\n$st');
    }
  }
} 