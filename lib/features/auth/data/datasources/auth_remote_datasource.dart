import 'package:team_18_final_project/features/auth/domain/entities/user_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_profile_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_settings_entity.dart';

/// Remote data source for authentication operations
/// Handles all Firebase Auth and Firestore operations
abstract class AuthRemoteDataSource {
  /// Signs in a user with email and password
  /// Throws FirebaseAuthException on failure
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Registers a new user with email and password
  /// Throws FirebaseAuthException on failure
  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
  });

  /// Signs out the current user
  Future<void> signOut();

  /// Gets the currently authenticated user
  /// Returns null if no user is authenticated
  Future<UserEntity?> getCurrentUser();

  /// Gets a user's profile from Firestore
  /// Throws FirebaseException if user not found or network error
  Future<UserProfileEntity> getUserProfile(String userId);

  /// Updates a user's profile in Firestore
  /// Throws FirebaseException on failure
  Future<void> updateUserProfile(UserProfileEntity profile);

  /// Gets a user's settings from Firestore
  /// Throws FirebaseException if settings not found or network error
  Future<UserSettingsEntity> getUserSettings(String userId);

  /// Updates a user's settings in Firestore
  /// Throws FirebaseException on failure
  Future<void> updateUserSettings(UserSettingsEntity settings);

  /// Creates initial user document in Firestore after registration
  /// Throws FirebaseException on failure
  Future<void> createUserDocument({
    required String userId,
    required String email,
    String? displayName,
    String? phoneNumber,
  });

  /// Deletes the current user account
  /// Throws FirebaseAuthException on failure
  Future<void> deleteAccount();

  /// Sends a password reset email
  /// Throws FirebaseAuthException on failure
  Future<void> sendPasswordResetEmail(String email);

  /// Updates the user's email address
  /// Throws FirebaseAuthException on failure
  Future<void> updateEmail(String newEmail);

  /// Updates the user's password
  /// Throws FirebaseAuthException on failure
  Future<void> updatePassword(String newPassword);

  /// Re-authenticates the user (required for sensitive operations)
  /// Throws FirebaseAuthException on failure
  Future<void> reauthenticate({
    required String email,
    required String password,
  });
}
