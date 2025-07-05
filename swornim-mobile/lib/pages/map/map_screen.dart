import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swornim/pages/providers/service_providers/service_provider_factory.dart';
import 'package:swornim/pages/providers/service_providers/service_providers.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(27.7172, 85.3240), // Default to Kathmandu
    zoom: 12,
  );

  final Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAndSetMarkers();
    });
  }

  Future<void> _fetchAndSetMarkers() async {
    final serviceProviderManager = ref.read(serviceProviderManagerProvider);
    final result =
        await serviceProviderManager.getServiceProviders(ServiceProviderType.venue);

    if (mounted) {
      if (result.success && result.data != null) {
        final Set<Marker> newMarkers = {};
        for (final provider in result.data!) {
          if (provider.location != null) {
            newMarkers.add(
              Marker(
                markerId: MarkerId(provider.id),
                position: LatLng(
                  provider.location!.latitude,
                  provider.location!.longitude,
                ),
                infoWindow: InfoWindow(
                  title: provider.businessName,
                  snippet: provider.description.length > 50
                      ? '${provider.description.substring(0, 50)}...'
                      : provider.description,
                ),
              ),
            );
          }
        }
        setState(() {
          _markers.addAll(newMarkers);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.error ?? 'Failed to load locations')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services Near You'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              markers: _markers,
            ),
    );
  }
} 