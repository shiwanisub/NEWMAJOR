import 'package:swornim/pages/models/location.dart';

class Meetup {
  final String id;
  final String organizerId; // User ID who created the meetup
  final String title;
  final String description;
  final String category; // 'social', 'professional', 'hobby', 'sports', etc.
  final DateTime dateTime;
  final Duration duration;
  final Location location;
  final int maxParticipants;
  final int currentParticipants;
  final List<String> participantIds; // User IDs who joined
  final List<String> tags;
  final String? imageUrl;
  final bool isPublic;
  final bool requiresApproval;
  final double? entryFee;
  final MeetupStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? requirements; // Age limit, skill level, etc.
  final List<String> amenities; // What's provided
  final String? contactInfo;

  const Meetup({
    required this.id,
    required this.organizerId,
    required this.title,
    required this.description,
    required this.category,
    required this.dateTime,
    required this.duration,
    required this.location,
    this.maxParticipants = 50,
    this.currentParticipants = 0,
    this.participantIds = const [],
    this.tags = const [],
    this.imageUrl,
    this.isPublic = true,
    this.requiresApproval = false,
    this.entryFee,
    this.status = MeetupStatus.upcoming,
    required this.createdAt,
    required this.updatedAt,
    this.requirements,
    this.amenities = const [],
    this.contactInfo,
  });

  bool get hasSpaceAvailable => currentParticipants < maxParticipants;
  bool get isFull => currentParticipants >= maxParticipants;
  bool get isActive => status == MeetupStatus.upcoming || status == MeetupStatus.ongoing;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organizer_id': organizerId,
      'title': title,
      'description': description,
      'category': category,
      'date_time': dateTime.toIso8601String(),
      'duration': duration.inMinutes,
      'location': location.toJson(),
      'max_participants': maxParticipants,
      'current_participants': currentParticipants,
      'participant_ids': participantIds,
      'tags': tags,
      'image_url': imageUrl,
      'is_public': isPublic,
      'requires_approval': requiresApproval,
      'entry_fee': entryFee,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'requirements': requirements,
      'amenities': amenities,
      'contact_info': contactInfo,
    };
  }

  factory Meetup.fromJson(Map<String, dynamic> json) {
    return Meetup(
      id: json['id'],
      organizerId: json['organizer_id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      dateTime: DateTime.parse(json['date_time']),
      duration: Duration(minutes: json['duration']),
      location: Location.fromJson(json['location']),
      maxParticipants: json['max_participants'] ?? 50,
      currentParticipants: json['current_participants'] ?? 0,
      participantIds: List<String>.from(json['participant_ids'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      imageUrl: json['image_url'],
      isPublic: json['is_public'] ?? true,
      requiresApproval: json['requires_approval'] ?? false,
      entryFee: json['entry_fee']?.toDouble(),
      status: MeetupStatus.values.byName(json['status'] ?? 'upcoming'),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      requirements: json['requirements'],
      amenities: List<String>.from(json['amenities'] ?? []),
      contactInfo: json['contact_info'],
    );
  }

  Meetup copyWith({
    String? id,
    String? organizerId,
    String? title,
    String? description,
    String? category,
    DateTime? dateTime,
    Duration? duration,
    Location? location,
    int? maxParticipants,
    int? currentParticipants,
    List<String>? participantIds,
    List<String>? tags,
    String? imageUrl,
    bool? isPublic,
    bool? requiresApproval,
    double? entryFee,
    MeetupStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? requirements,
    List<String>? amenities,
    String? contactInfo,
  }) {
    return Meetup(
      id: id ?? this.id,
      organizerId: organizerId ?? this.organizerId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      participantIds: participantIds ?? this.participantIds,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      isPublic: isPublic ?? this.isPublic,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      entryFee: entryFee ?? this.entryFee,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      requirements: requirements ?? this.requirements,
      amenities: amenities ?? this.amenities,
      contactInfo: contactInfo ?? this.contactInfo,
    );
  }
}

enum MeetupStatus { upcoming, ongoing, completed, cancelled }