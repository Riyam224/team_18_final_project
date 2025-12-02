import 'package:equatable/equatable.dart';

/// Pure domain entity representing a user profile
class UserProfileEntity extends Equatable {
  final String userId;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final String? avatarUrl;
  final String? bio;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfileEntity({
    required this.userId,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.avatarUrl,
    this.bio,
    this.createdAt,
    this.updatedAt,
  });

  /// Creates a copy of this entity with the given fields replaced with new values
  UserProfileEntity copyWith({
    String? userId,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    String? avatarUrl,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        displayName,
        phoneNumber,
        photoUrl,
        avatarUrl,
        bio,
        createdAt,
        updatedAt,
      ];

  @override
  bool get stringify => true;
}
