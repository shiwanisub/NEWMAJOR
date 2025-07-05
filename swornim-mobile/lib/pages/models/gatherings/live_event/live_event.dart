import 'package:swornim/pages/models/location.dart';

class LiveEvent {
  final String id;
  final String organizerId; // Can be a user or service provider
  final String title;
  final String description;
  final String category; // 'concert', 'workshop', 'exhibition', 'conference', etc.
  final EventType eventType;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final Location location;
  final int maxCapacity;
  final int currentAttendees;
  final List<String> attendeeIds;
  final double? ticketPrice;
  final bool isFree;
  final String? imageUrl;
  final List<String> images; // Multiple event images
  final bool isPublic;
  final bool requiresRegistration;
  final LiveEventStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final String? ageRestriction;
  final List<String> speakers; // For conferences/workshops
  final List<String> performers; // For concerts/shows
  final String? agenda; // Event schedule
  final List<String> sponsors;
  final String? livestreamUrl; // For hybrid events
  final bool isLivestreamed;
  final Map<String, dynamic>? metadata; // Additional event-specific data

  const LiveEvent({
    required this.id,
    required this.organizerId,
    required this.title,
    required this.description,
    required this.category,
    required this.eventType,
    required this.startDateTime,
    required this.endDateTime,
    required this.location,
    this.maxCapacity = 100,
    this.currentAttendees = 0,
    this.attendeeIds = const [],
    this.ticketPrice,
    this.isFree = true,
    this.imageUrl,
    this.images = const [],
    this.isPublic = true,
    this.requiresRegistration = false,
    this.status = LiveEventStatus.upcoming,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.ageRestriction,
    this.speakers = const [],
    this.performers = const [],
    this.agenda,
    this.sponsors = const [],
    this.livestreamUrl,
    this.isLivestreamed = false,
    this.metadata,
  });

  bool get hasSpaceAvailable => currentAttendees < maxCapacity;
  bool get isFull => currentAttendees >= maxCapacity;
  bool get isActive => status == LiveEventStatus.upcoming || status == LiveEventStatus.live;
  bool get isOngoing => status == LiveEventStatus.live;
  Duration get duration => endDateTime.difference(startDateTime);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organizer_id': organizerId,
      'title': title,
      'description': description,
      'category': category,
      'event_type': eventType.name,
      'start_date_time': startDateTime.toIso8601String(),
      'end_date_time': endDateTime.toIso8601String(),
      'location': location.toJson(),
      'max_capacity': maxCapacity,
      'current_attendees': currentAttendees,
      'attendee_ids': attendeeIds,
      'ticket_price': ticketPrice,
      'is_free': isFree,
      'image_url': imageUrl,
      'images': images,
      'is_public': isPublic,
      'requires_registration': requiresRegistration,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'tags': tags,
      'age_restriction': ageRestriction,
      'speakers': speakers,
      'performers': performers,
      'agenda': agenda,
      'sponsors': sponsors,
      'livestream_url': livestreamUrl,
      'is_livestreamed': isLivestreamed,
      'metadata': metadata,
    };
  }

  factory LiveEvent.fromJson(Map<String, dynamic> json) {
    return LiveEvent(
      id: json['id'],
      organizerId: json['organizer_id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      eventType: EventType.values.byName(json['event_type']),
      startDateTime: DateTime.parse(json['start_date_time']),
      endDateTime: DateTime.parse(json['end_date_time']),
      location: Location.fromJson(json['location']),
      maxCapacity: json['max_capacity'] ?? 100,
      currentAttendees: json['current_attendees'] ?? 0,
      attendeeIds: List<String>.from(json['attendee_ids'] ?? []),
      ticketPrice: json['ticket_price']?.toDouble(),
      isFree: json['is_free'] ?? true,
      imageUrl: json['image_url'],
      images: List<String>.from(json['images'] ?? []),
      isPublic: json['is_public'] ?? true,
      requiresRegistration: json['requires_registration'] ?? false,
      status: LiveEventStatus.values.byName(json['status'] ?? 'upcoming'),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      tags: List<String>.from(json['tags'] ?? []),
      ageRestriction: json['age_restriction'],
      speakers: List<String>.from(json['speakers'] ?? []),
      performers: List<String>.from(json['performers'] ?? []),
      agenda: json['agenda'],
      sponsors: List<String>.from(json['sponsors'] ?? []),
      livestreamUrl: json['livestream_url'],
      isLivestreamed: json['is_livestreamed'] ?? false,
      metadata: json['metadata'],
    );
  }

  LiveEvent copyWith({
    String? id,
    String? organizerId,
    String? title,
    String? description,
    String? category,
    EventType? eventType,
    DateTime? startDateTime,
    DateTime? endDateTime,
    Location? location,
    int? maxCapacity,
    int? currentAttendees,
    List<String>? attendeeIds,
    double? ticketPrice,
    bool? isFree,
    String? imageUrl,
    List<String>? images,
    bool? isPublic,
    bool? requiresRegistration,
    LiveEventStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    String? ageRestriction,
    List<String>? speakers,
    List<String>? performers,
    String? agenda,
    List<String>? sponsors,
    String? livestreamUrl,
    bool? isLivestreamed,
    Map<String, dynamic>? metadata,
  }) {
    return LiveEvent(
      id: id ?? this.id,
      organizerId: organizerId ?? this.organizerId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      eventType: eventType ?? this.eventType,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      location: location ?? this.location,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      currentAttendees: currentAttendees ?? this.currentAttendees,
      attendeeIds: attendeeIds ?? this.attendeeIds,
      ticketPrice: ticketPrice ?? this.ticketPrice,
      isFree: isFree ?? this.isFree,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      isPublic: isPublic ?? this.isPublic,
      requiresRegistration: requiresRegistration ?? this.requiresRegistration,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      ageRestriction: ageRestriction ?? this.ageRestriction,
      speakers: speakers ?? this.speakers,
      performers: performers ?? this.performers,
      agenda: agenda ?? this.agenda,
      sponsors: sponsors ?? this.sponsors,
      livestreamUrl: livestreamUrl ?? this.livestreamUrl,
      isLivestreamed: isLivestreamed ?? this.isLivestreamed,
      metadata: metadata ?? this.metadata,
    );
  }
}

enum EventType { 
  concert, 
  workshop, 
  conference, 
  exhibition, 
  seminar, 
  festival, 
  sports, 
  networking, 
  performance, 
  competition 
}

enum LiveEventStatus { upcoming, live, completed, cancelled, postponed }