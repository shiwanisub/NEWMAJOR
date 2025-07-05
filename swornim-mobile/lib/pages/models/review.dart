class Review {
  final String id;
  final String bookingId;
  final String clientId;
  final String serviceProviderId;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String>? images;

  Review({
    required this.id,
    required this.bookingId,
    required this.clientId,
    required this.serviceProviderId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.images,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      bookingId: json['booking_id'],
      clientId: json['client_id'],
      serviceProviderId: json['service_provider_id'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
      images: json['images'] != null ? List<String>.from(json['images']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'client_id': clientId,
      'service_provider_id': serviceProviderId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'images': images,
    };
  }
}