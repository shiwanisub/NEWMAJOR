// File: lib/services/auth_service.dart
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
// import 'package:swornim/pages/models/user.dart';
import 'package:swornim/pages/models/user/user.dart';
import 'package:swornim/pages/models/user/user_types.dart' as types;


class AuthService {
  static String hashPassword(String password) {
    // Add a random salt for better security
    final salt = 'your_app_salt_here'; // Use a proper salt in production
    var bytes = utf8.encode(password + salt);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static bool verifyPassword(String password, String hash) {
    return hashPassword(password) == hash;
  }

  static User signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    required types.UserType userType,
  }) {
    return User(
      id: _generateId(),
      name: name,
      email: email,
      phone: phone,
      userType: userType,
      passwordHash: hashPassword(password),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
      isEmailVerified: false,
    );
  }

  static User? login(String email, String password, List<User> users) {
    try {
      final user = users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
      
      if (!user.canLogin()) {
        throw Exception('Account not active or email not verified');
      }
      
      if (user.passwordHash != null && 
          verifyPassword(password, user.passwordHash!)) {
        return user;
      }
      
      throw Exception('Invalid password');
    } catch (e) {
      return null;
    }
  }

  static String _generateId() {
    // Simple ID generation - use UUID in production
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           Random().nextInt(9999).toString();
  }

  // Helper method to check if user can access service provider features
  static bool canAccessServiceProviderFeatures(User user) {
    return user.userType != types.UserType.client && user.isActive;
  }

  // Get user role display name
  static String getUserRoleDisplayName(types.UserType userType) {
    switch (userType) {
      case types.UserType.client:
        return 'Client';
      case types.UserType.photographer:
        return 'Photographer';
      case types.UserType.makeupArtist:
        return 'Makeup Artist';
      case types.UserType.decorator:
        return 'Decorator';
      case types.UserType.venue:
        return 'Venue Owner';
      case types.UserType.caterer:
        return 'Caterer';
      case types.UserType.eventOrganizer:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}

// Usage example:
void exampleUsage() {
  // Signup
  final newUser = AuthService.signup(
    name: 'Jane Smith',
    email: 'jane@example.com',
    phone: '9876543210',
    password: 'securePassword123',
    userType: types.UserType.photographer,
  );

  print('User created: ${newUser.name} as ${AuthService.getUserRoleDisplayName(types.UserType.values[newUser.userType.index])}');

  // Login
  List<User> users = [newUser];
  
  // This would fail because email is not verified
  var loginResult = AuthService.login('jane@example.com', 'securePassword123', users);
  print('Login result: ${loginResult != null ? 'Success' : 'Failed (email not verified)'}');

  // Simulate email verification
  final verifiedUser = User(
    id: newUser.id,
    name: newUser.name,
    email: newUser.email,
    phone: newUser.phone,
    userType: newUser.userType,
    passwordHash: newUser.passwordHash,
    createdAt: newUser.createdAt,
    updatedAt: DateTime.now(),
    isActive: true,
    isEmailVerified: true, // Now verified
  );

  users = [verifiedUser];
  loginResult = AuthService.login('jane@example.com', 'securePassword123', users);
  print('Login after verification: ${loginResult != null ? 'Success' : 'Failed'}');

  // Check service provider access
  if (loginResult != null) {
    final canAccess = AuthService.canAccessServiceProviderFeatures(loginResult);
    print('Can access service provider features: $canAccess');
  }
}