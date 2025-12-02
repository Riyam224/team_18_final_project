import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:team_18_final_project/core/config/firebase_config.dart';
import 'package:team_18_final_project/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:team_18_final_project/features/auth/data/mappers/profile_mapper.dart';
import 'package:team_18_final_project/features/auth/data/mappers/settings_mapper.dart';
import 'package:team_18_final_project/features/auth/data/mappers/user_mapper.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_profile_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_settings_entity.dart';

/// Implementation of AuthRemoteDataSource using Firebase
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user found after sign in',
      );
    }

    // Update last login in Firestore
    await _updateLastLogin(userCredential.user!.uid, email);

    return UserMapper.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'registration-failed',
        message: 'Failed to create user',
      );
    }

    final user = userCredential.user!;

    // Update display name if provided
    if (displayName != null) {
      await user.updateDisplayName(displayName);
    }

    // Create user document in Firestore
    await createUserDocument(
      userId: user.uid,
      email: email,
      displayName: displayName,
      phoneNumber: phoneNumber,
    );

    // Reload user to get updated data
    await user.reload();
    final updatedUser = _firebaseAuth.currentUser;

    if (updatedUser == null) {
      return UserMapper.fromFirebaseUser(user);
    }

    return UserMapper.fromFirebaseUser(updatedUser);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return UserMapper.fromFirebaseUser(user);
  }

  @override
  Future<UserProfileEntity> getUserProfile(String userId) async {
    final doc = await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .get();

    if (!doc.exists) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'not-found',
        message: 'User profile not found',
      );
    }

    final data = doc.data();
    if (data == null || !data.containsKey(FirebaseConfig.profileField)) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'invalid-data',
        message: 'Profile data is invalid',
      );
    }

    final profileData = data[FirebaseConfig.profileField] as Map<String, dynamic>;
    return ProfileMapper.fromFirestore(userId, profileData);
  }

  @override
  Future<void> updateUserProfile(UserProfileEntity profile) async {
    final profileData = ProfileMapper.toFirestore(profile);

    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(profile.userId)
        .set({
      FirebaseConfig.profileField: profileData,
      FirebaseConfig.updatedAtField: FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<UserSettingsEntity> getUserSettings(String userId) async {
    final doc = await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .get();

    if (!doc.exists) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'not-found',
        message: 'User settings not found',
      );
    }

    final data = doc.data();
    if (data == null || !data.containsKey(FirebaseConfig.settingsField)) {
      // Return default settings if not found
      return UserSettingsEntity(userId: userId);
    }

    final settingsData = data[FirebaseConfig.settingsField] as Map<String, dynamic>;
    return SettingsMapper.fromFirestore(userId, settingsData);
  }

  @override
  Future<void> updateUserSettings(UserSettingsEntity settings) async {
    final settingsData = SettingsMapper.toFirestore(settings);

    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(settings.userId)
        .set({
      FirebaseConfig.settingsField: settingsData,
      FirebaseConfig.settingsUpdatedAtField: FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> createUserDocument({
    required String userId,
    required String email,
    String? displayName,
    String? phoneNumber,
  }) async {
    final userEntity = UserEntity(
      id: userId,
      email: email,
      displayName: displayName,
      phoneNumber: phoneNumber,
      createdAt: DateTime.now(),
    );

    final userData = UserMapper.toFirestore(userEntity);

    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .set({
      FirebaseConfig.profileField: userData,
      FirebaseConfig.createdAtField: FieldValue.serverTimestamp(),
      FirebaseConfig.updatedAtField: FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Create default settings
    final defaultSettings = UserSettingsEntity(userId: userId);
    await updateUserSettings(defaultSettings);
  }

  @override
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'no-current-user',
        message: 'No user is currently signed in',
      );
    }

    // Delete Firestore document
    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(user.uid)
        .delete();

    // Delete authentication account
    await user.delete();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> updateEmail(String newEmail) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'no-current-user',
        message: 'No user is currently signed in',
      );
    }

    await user.verifyBeforeUpdateEmail(newEmail);

    // Update email in Firestore
    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(user.uid)
        .update({
      '${FirebaseConfig.profileField}.${FirebaseConfig.emailField}': newEmail,
      FirebaseConfig.updatedAtField: FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'no-current-user',
        message: 'No user is currently signed in',
      );
    }

    await user.updatePassword(newPassword);
  }

  @override
  Future<void> reauthenticate({
    required String email,
    required String password,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'no-current-user',
        message: 'No user is currently signed in',
      );
    }

    final credential = firebase_auth.EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);
  }

  /// Updates last login timestamp in Firestore
  Future<void> _updateLastLogin(String userId, String email) async {
    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .set({
      FirebaseConfig.securityField: {
        FirebaseConfig.lastLoginAtField: FieldValue.serverTimestamp(),
        FirebaseConfig.lastLoginEmailField: email,
      },
    }, SetOptions(merge: true));
  }
}
