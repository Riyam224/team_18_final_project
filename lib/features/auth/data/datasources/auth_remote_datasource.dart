import 'package:team_18_final_project/features/auth/domain/entities/user_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_profile_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_settings_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
  });

  Future<void> signOut();

  Future<UserEntity?> getCurrentUser();

  Future<UserProfileEntity> getUserProfile(String userId);

  Future<void> updateUserProfile(UserProfileEntity profile);

  Future<UserSettingsEntity> getUserSettings(String userId);

  Future<void> updateUserSettings(UserSettingsEntity settings);

  Future<void> createUserDocument({
    required String userId,
    required String email,
    String? displayName,
    String? phoneNumber,
  });

  Future<void> deleteAccount();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> updateEmail(String newEmail);

  Future<void> updatePassword(String newPassword);

  Future<void> reauthenticate({
    required String email,
    required String password,
  });
}
