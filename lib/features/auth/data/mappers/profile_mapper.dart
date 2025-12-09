import 'package:team_18_final_project/core/config/firebase_config.dart';
import 'package:team_18_final_project/features/auth/data/models/user_profile.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_profile_entity.dart';

/// Mapper class to convert between UserProfile (data) and UserProfileEntity (domain)
class ProfileMapper {
  const ProfileMapper._();

  /// Converts UserProfile model to UserProfileEntity
  static UserProfileEntity fromModel(UserProfile model, String userId) {
    return UserProfileEntity(
      userId: userId,
      email: model.email,
      displayName: model.displayName,
      phoneNumber: model.phone.isNotEmpty ? model.phone : null,
    );
  }

  /// Converts UserProfileEntity to UserProfile model
  static UserProfile toModel(UserProfileEntity entity) {
    // Extract first and last name from displayName
    final nameParts = entity.displayName?.split(' ') ?? [];
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return UserProfile(
      firstName: firstName,
      lastName: lastName,
      email: entity.email,
      phone: entity.phoneNumber ?? '',
    );
  }

  /// Converts UserProfileEntity to Firestore Map
  static Map<String, dynamic> toFirestore(UserProfileEntity entity) {
    // Extract first and last name from displayName
    final nameParts = entity.displayName?.split(' ') ?? [];
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return {
      FirebaseConfig.emailField: entity.email,
      'firstName': firstName,
      'lastName': lastName,
      FirebaseConfig.phoneNumberField: entity.phoneNumber ?? '',
      FirebaseConfig.photoUrlField: entity.photoUrl,
      FirebaseConfig.avatarUrlField: entity.avatarUrl,
      'bio': entity.bio,
      FirebaseConfig.updatedAtField: DateTime.now().toIso8601String(),
    };
  }

  /// Converts Firestore Map to UserProfileEntity
  static UserProfileEntity fromFirestore(
      String userId, Map<String, dynamic> data) {
    final firstName = data['firstName'] as String? ?? '';
    final lastName = data['lastName'] as String? ?? '';
    final displayName =
        [firstName, lastName].where((e) => e.isNotEmpty).join(' ').trim();

    return UserProfileEntity(
      userId: userId,
      email: data[FirebaseConfig.emailField] as String? ?? '',
      displayName: displayName.isNotEmpty ? displayName : null,
      phoneNumber: data[FirebaseConfig.phoneNumberField] as String?,
      photoUrl: data[FirebaseConfig.photoUrlField] as String?,
      avatarUrl: data[FirebaseConfig.avatarUrlField] as String?,
      bio: data['bio'] as String?,
      createdAt: data[FirebaseConfig.createdAtField] != null
          ? DateTime.parse(data[FirebaseConfig.createdAtField] as String)
          : null,
      updatedAt: data[FirebaseConfig.updatedAtField] != null
          ? DateTime.parse(data[FirebaseConfig.updatedAtField] as String)
          : null,
    );
  }
}
