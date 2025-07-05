import 'package:swornim/pages/providers/service_providers/models/base_service_provider.dart';
import 'package:swornim/pages/models/review.dart';
import 'package:swornim/pages/models/location.dart';

class EventOrganizer extends ServiceProvider {
  final List<String> eventTypes; // ['wedding', 'corporate', 'birthday', 'conference']
  final List<String> services; // ['full_planning', 'coordination', 'consultation']
  final double packageStartingPrice;
  final double hourlyConsultationRate;
  final List<String> portfolio;
  final int experienceYears;
  final int maxEventSize;
  final List<String> preferredVendors; // Partner service provider IDs
  final bool offersVendorManagement;
  final bool offersEventCoordination;
  final List<String> availableDates;

  const EventOrganizer({
    required super.id,
    required super.userId,
    required super.businessName,
    required super.image,
    required super.description,
    super.rating,
    super.totalReviews,
    super.isAvailable,
    super.reviews,
    super.location,
    required super.createdAt,
    required super.updatedAt,
    this.eventTypes = const [],
    this.services = const [],
    required this.packageStartingPrice,
    required this.hourlyConsultationRate,
    this.portfolio = const [],
    this.experienceYears = 0,
    this.maxEventSize = 1000,
    this.preferredVendors = const [],
    this.offersVendorManagement = true,
    this.offersEventCoordination = true,
    this.availableDates = const [],
  });

  @override
  Map<String, dynamic> toJson() {
    final baseJson = toBaseJson();
    baseJson.addAll({
      'type': 'event_organizer',
      'event_types': eventTypes,
      'services': services,
      'package_starting_price': packageStartingPrice,
      'hourly_consultation_rate': hourlyConsultationRate,
      'portfolio': portfolio,
      'experience_years': experienceYears,
      'max_event_size': maxEventSize,
      'preferred_vendors': preferredVendors,
      'offers_vendor_management': offersVendorManagement,
      'offers_event_coordination': offersEventCoordination,
      'available_dates': availableDates,
    });
    return baseJson;
  }

  factory EventOrganizer.fromJson(Map<String, dynamic> json) {
    return EventOrganizer(
      id: json['id'],
      userId: json['user_id'],
      businessName: json['business_name'],
      image: json['image'],
      description: json['description'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      isAvailable: json['is_available'] ?? true,
      reviews: (json['reviews'] as List<dynamic>?)?.map((r) => Review.fromJson(r)).toList() ?? [],
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      eventTypes: List<String>.from(json['event_types'] ?? []),
      services: List<String>.from(json['services'] ?? []),
      packageStartingPrice: (json['package_starting_price'] ?? 0.0).toDouble(),
      hourlyConsultationRate: (json['hourly_consultation_rate'] ?? 0.0).toDouble(),
      portfolio: List<String>.from(json['portfolio'] ?? []),
      experienceYears: json['experience_years'] ?? 0,
      maxEventSize: json['max_event_size'] ?? 1000,
      preferredVendors: List<String>.from(json['preferred_vendors'] ?? []),
      offersVendorManagement: json['offers_vendor_management'] ?? true,
      offersEventCoordination: json['offers_event_coordination'] ?? true,
      availableDates: List<String>.from(json['available_dates'] ?? []),
    );
  }

  @override
  EventOrganizer copyWith({
    String? id,
    String? userId,
    String? businessName,
    String? image,
    String? description,
    double? rating,
    int? totalReviews,
    bool? isAvailable,
    List<Review>? reviews,
    Location? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? eventTypes,
    List<String>? services,
    double? packageStartingPrice,
    double? hourlyConsultationRate,
    List<String>? portfolio,
    int? experienceYears,
    int? maxEventSize,
    List<String>? preferredVendors,
    bool? offersVendorManagement,
    bool? offersEventCoordination,
    List<String>? availableDates,
  }) {
    return EventOrganizer(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessName: businessName ?? this.businessName,
      image: image ?? this.image,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      isAvailable: isAvailable ?? this.isAvailable,
      reviews: reviews ?? this.reviews,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      eventTypes: eventTypes ?? this.eventTypes,
      services: services ?? this.services,
      packageStartingPrice: packageStartingPrice ?? this.packageStartingPrice,
      hourlyConsultationRate: hourlyConsultationRate ?? this.hourlyConsultationRate,
      portfolio: portfolio ?? this.portfolio,
      experienceYears: experienceYears ?? this.experienceYears,
      maxEventSize: maxEventSize ?? this.maxEventSize,
      preferredVendors: preferredVendors ?? this.preferredVendors,
      offersVendorManagement: offersVendorManagement ?? this.offersVendorManagement,
      offersEventCoordination: offersEventCoordination ?? this.offersEventCoordination,
      availableDates: availableDates ?? this.availableDates,
    );
  }
}