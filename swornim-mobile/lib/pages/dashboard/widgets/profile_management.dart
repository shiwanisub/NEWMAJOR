import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swornim/pages/models/user/user.dart';
import 'package:swornim/pages/models/bookings/service_package.dart';
import 'package:swornim/pages/components/common/common/profile/profile_panel.dart';

class ProfileManagement extends ConsumerStatefulWidget {
  final User provider;
  
  const ProfileManagement({required this.provider, Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileManagement> createState() => _ProfileManagementState();
}

class _ProfileManagementState extends ConsumerState<ProfileManagement> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  
  // Form controllers
  final _businessNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _loadProfileData() {
    _businessNameController.text = widget.provider.name;
    _descriptionController.text = 'Professional service provider with years of experience in event management and customer satisfaction.';
    _phoneController.text = widget.provider.phone ?? '';
    _emailController.text = widget.provider.email;
    _addressController.text = 'Kathmandu, Nepal';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          _buildProfileHeader(theme, colorScheme),
          const SizedBox(height: 24),

          // Business Profile Section
          _buildBusinessProfile(theme, colorScheme),
          const SizedBox(height: 24),

          // Service Area Management
          _buildServiceAreaManagement(theme, colorScheme),
          const SizedBox(height: 24),

          // Availability Settings
          _buildAvailabilitySettings(theme, colorScheme),
          const SizedBox(height: 24),

          // Portfolio/Gallery Management
          _buildPortfolioManagement(theme, colorScheme),
          const SizedBox(height: 24),

          // Settings Section
          _buildSettingsSection(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 40,
            backgroundColor: colorScheme.primary.withOpacity(0.1),
            child: widget.provider.profileImage != null
                ? ClipOval(
                    child: Image.network(
                      widget.provider.profileImage!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 40,
                          color: colorScheme.primary,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 40,
                    color: colorScheme.primary,
                  ),
          ),
          const SizedBox(width: 16),
          
          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.provider.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Service Provider',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '4.8 (124 reviews)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Edit Button
          IconButton(
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              color: colorScheme.primary,
            ),
            tooltip: _isEditing ? 'Save Changes' : 'Edit Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessProfile(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.business,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Business Profile',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildFormField(
                  controller: _businessNameController,
                  label: 'Business Name',
                  icon: Icons.store,
                  enabled: _isEditing,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  controller: _descriptionController,
                  label: 'Description',
                  icon: Icons.description,
                  enabled: _isEditing,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone,
                  enabled: _isEditing,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  enabled: _isEditing,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  controller: _addressController,
                  label: 'Address',
                  icon: Icons.location_on,
                  enabled: _isEditing,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceAreaManagement(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Service Area',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              if (_isEditing)
                IconButton(
                  onPressed: _addServiceArea,
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Service Area',
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Service Areas List
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Kathmandu',
              'Lalitpur',
              'Bhaktapur',
              'Pokhara',
            ].map((area) => Chip(
              label: Text(area),
              deleteIcon: _isEditing ? const Icon(Icons.close, size: 16) : null,
              onDeleted: _isEditing ? () => _removeServiceArea(area) : null,
              backgroundColor: colorScheme.primary.withOpacity(0.1),
              deleteIconColor: colorScheme.error,
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilitySettings(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Availability Settings',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Working Hours
          _buildWorkingHours(theme, colorScheme),
          const SizedBox(height: 16),
          
          // Availability Toggle
          Row(
            children: [
              Expanded(
                child: Text(
                  'Available for Bookings',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Switch(
                value: true, // TODO: Get from provider
                onChanged: _isEditing ? (value) {
                  // TODO: Update availability
                } : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHours(ThemeData theme, ColorScheme colorScheme) {
    final workingDays = [
      {'day': 'Monday', 'hours': '9:00 AM - 6:00 PM'},
      {'day': 'Tuesday', 'hours': '9:00 AM - 6:00 PM'},
      {'day': 'Wednesday', 'hours': '9:00 AM - 6:00 PM'},
      {'day': 'Thursday', 'hours': '9:00 AM - 6:00 PM'},
      {'day': 'Friday', 'hours': '9:00 AM - 6:00 PM'},
      {'day': 'Saturday', 'hours': '10:00 AM - 4:00 PM'},
      {'day': 'Sunday', 'hours': 'Closed'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Working Hours',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        ...workingDays.map((day) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  day['day']!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  day['hours']!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              if (_isEditing)
                IconButton(
                  onPressed: () => _editWorkingHours(day['day']!),
                  icon: const Icon(Icons.edit, size: 16),
                  tooltip: 'Edit hours',
                ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildPortfolioManagement(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.photo_library,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Portfolio & Gallery',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              if (_isEditing)
                IconButton(
                  onPressed: _addPortfolioImage,
                  icon: const Icon(Icons.add_photo_alternate),
                  tooltip: 'Add Image',
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Portfolio Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 6, // Sample images
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.image,
                        size: 32,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (_isEditing)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removePortfolioImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: colorScheme.error,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Settings',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Settings Options
          _buildSettingsOption(
            icon: Icons.notifications,
            title: 'Notification Preferences',
            subtitle: 'Manage email and push notifications',
            onTap: _openNotificationSettings,
          ),
          _buildSettingsOption(
            icon: Icons.auto_awesome,
            title: 'Auto-confirm Bookings',
            subtitle: 'Automatically confirm booking requests',
            onTap: _openAutoConfirmSettings,
          ),
          _buildSettingsOption(
            icon: Icons.price_check,
            title: 'Pricing Rules',
            subtitle: 'Set dynamic pricing and discounts',
            onTap: _openPricingSettings,
          ),
          _buildSettingsOption(
            icon: Icons.description,
            title: 'Terms & Conditions',
            subtitle: 'Manage your business terms',
            onTap: _openTermsSettings,
          ),
          _buildSettingsOption(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: _handleLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _addServiceArea() {
    // TODO: Implement add service area
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add service area functionality')),
    );
  }

  void _removeServiceArea(String area) {
    // TODO: Implement remove service area
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Remove service area: $area')),
    );
  }

  void _editWorkingHours(String day) {
    // TODO: Implement edit working hours
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit working hours for $day')),
    );
  }

  void _addPortfolioImage() {
    // TODO: Implement add portfolio image
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add portfolio image functionality')),
    );
  }

  void _removePortfolioImage(int index) {
    // TODO: Implement remove portfolio image
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Remove portfolio image at index $index')),
    );
  }

  void _openNotificationSettings() {
    // TODO: Navigate to notification settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Open notification settings')),
    );
  }

  void _openAutoConfirmSettings() {
    // TODO: Navigate to auto-confirm settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Open auto-confirm settings')),
    );
  }

  void _openPricingSettings() {
    // TODO: Navigate to pricing settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Open pricing settings')),
    );
  }

  void _openTermsSettings() {
    // TODO: Navigate to terms settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Open terms settings')),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => const ProfilePanel(),
    );
  }
} 