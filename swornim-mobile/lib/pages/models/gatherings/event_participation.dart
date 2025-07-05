class EventParticipation {
  final String id;
  final String userId;
  final String eventId;
  final String eventType; // 'meetup' or 'live_event'
  final ParticipationStatus status;
  final DateTime joinedAt;
  final DateTime? checkedInAt;
  final String? notes;
  final double? rating; // User's rating of the event
  final String? review; // User's review

  const EventParticipation({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.eventType,
    this.status = ParticipationStatus.registered,
    required this.joinedAt,
    this.checkedInAt,
    this.notes,
    this.rating,
    this.review,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'event_id': eventId,
      'event_type': eventType,
      'status': status.name,
      'joined_at': joinedAt.toIso8601String(),
      'checked_in_at': checkedInAt?.toIso8601String(),
      'notes': notes,
      'rating': rating,
      'review': review,
    };
  }

  factory EventParticipation.fromJson(Map<String, dynamic> json) {
    return EventParticipation(
      id: json['id'],
      userId: json['user_id'],
      eventId: json['event_id'],
      eventType: json['event_type'],
      status: ParticipationStatus.values.byName(json['status'] ?? 'registered'),
      joinedAt: DateTime.parse(json['joined_at']),
      checkedInAt: json['checked_in_at'] != null ? DateTime.parse(json['checked_in_at']) : null,
      notes: json['notes'],
      rating: json['rating']?.toDouble(),
      review: json['review'],
    );
  }

  EventParticipation copyWith({
    String? id,
    String? userId,
    String? eventId,
    String? eventType,
    ParticipationStatus? status,
    DateTime? joinedAt,
    DateTime? checkedInAt,
    String? notes,
    double? rating,
    String? review,
  }) {
    return EventParticipation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      eventType: eventType ?? this.eventType,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }
}

enum ParticipationStatus { 
  registered, 
  waitlisted, 
  confirmed, 
  checkedIn, 
  attended, 
  noShow, 
  cancelled 
}