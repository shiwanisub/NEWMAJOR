import 'package:swornim/pages/models/bookings/booking.dart';

enum UserType { 
  client, 
  photographer, 
  makeupArtist, 
  decorator, 
  venue,
  caterer,
  eventOrganizer
}

enum UserStatus { 
  pending, 
  approved, 
  active, 
  suspended, 
  rejected, 
  inactive 
}

// Helper to map UserType to ServiceType
ServiceType? serviceTypeFromUserType(UserType userType) {
  switch (userType) {
    case UserType.photographer:
      return ServiceType.photography;
    case UserType.makeupArtist:
      return ServiceType.makeup;
    case UserType.decorator:
      return ServiceType.decoration;
    case UserType.venue:
      return ServiceType.venue;
    case UserType.caterer:
      return ServiceType.catering;
    case UserType.eventOrganizer:
      return ServiceType.planning;
    default:
      return null;
  }
}