import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:team_18_final_project/features/auth/data/models/user_model.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_entity.dart';

/// Mapper class to convert between UserModel (data) and UserEntity (domain)
class UserMapper {
  const UserMapper._();

  /// Converts Firebase User to UserEntity
  static UserEntity fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserEntity(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      phoneNumber: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoURL,
      isEmailVerified: firebaseUser.emailVerified,
      createdAt: firebaseUser.metadata.creationTime,
      updatedAt: firebaseUser.metadata.lastSignInTime,
    );
  }

  /// Converts UserModel to UserEntity
  /// Note: UserModel is used during registration and doesn't have id/timestamps
  static UserEntity fromModel(UserModel model, {String? userId}) {
    return UserEntity(
      id: userId ?? '',
      email: model.email,
      displayName: '${model.firstName} ${model.lastName}'.trim(),
      phoneNumber: model.phone.isNotEmpty ? model.phone : null,
      isEmailVerified: false,
    );
  }

  /// Converts UserEntity to Map for Firestore
  static Map<String, dynamic> toFirestore(UserEntity entity) {
    return {
      'email': entity.email,
      'displayName': entity.displayName,
      'phoneNumber': entity.phoneNumber,
      'photoUrl': entity.photoUrl,
      'isEmailVerified': entity.isEmailVerified,
      'createdAt': entity.createdAt?.toIso8601String(),
      'updatedAt': entity.updatedAt?.toIso8601String(),
    };
  }

  /// Converts Firestore Map to UserEntity
  static UserEntity fromFirestore(String userId, Map<String, dynamic> data) {
    return UserEntity(
      id: userId,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      photoUrl: data['photoUrl'] as String?,
      isEmailVerified: data['isEmailVerified'] as bool? ?? false,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : null,
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'] as String)
          : null,
    );
  }
}
