import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:team_18_final_project/core/config/firebase_config.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/features/auth/data/models/user_profile.dart';
import 'package:team_18_final_project/features/auth/data/models/user_settings.dart';

class FirebaseUserService {
  FirebaseUserService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseStorage? firebaseStorage,
    ISecureStorage? secureStorage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = firebaseStorage ?? FirebaseStorage.instance,
        _secureStorage = secureStorage!;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final ISecureStorage _secureStorage;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(FirebaseConfig.usersCollection);

  Stream<UserProfile?> watchProfile() async* {
    final uidResult = await _secureStorage.read(key: StorageKeysConfig.userId);
    final uid =
        _auth.currentUser?.uid ?? uidResult.fold((_) => null, (value) => value);
    if (uid == null) {
      yield await _localProfile();
      return;
    }

    yield* _users.doc(uid).snapshots().asyncMap((snap) async {
      if (!snap.exists) return await _localProfile();
      final data = snap.data();
      final profile =
          data?[FirebaseConfig.profileField] as Map<String, dynamic>?;
      if (profile == null) return await _localProfile();
      final userProfile = UserProfile.fromMap(profile);
      await _persistLocal(userProfile);
      return userProfile;
    });
  }

  Future<UserProfile?> fetchProfile() async {
    final uidResult = await _secureStorage.read(key: StorageKeysConfig.userId);
    final uid =
        _auth.currentUser?.uid ?? uidResult.fold((_) => null, (value) => value);
    if (uid == null) return _localProfile();

    final snap = await _users.doc(uid).get();
    if (!snap.exists) return _localProfile();

    final data = snap.data();
    final profile = data?[FirebaseConfig.profileField] as Map<String, dynamic>?;
    if (profile == null) return _localProfile();

    final userProfile = UserProfile.fromMap(profile);
    await _persistLocal(userProfile);
    return userProfile;
  }

  Future<void> updateProfile(UserProfile profile) async {
    final user = _auth.currentUser;
    final uidResult = await _secureStorage.read(key: StorageKeysConfig.userId);
    final uid = user?.uid ?? uidResult.fold((_) => null, (value) => value);
    if (uid == null) throw Exception('No logged-in user');

    await _users.doc(uid).set(
      {
        FirebaseConfig.profileField: profile.toMap(),
        FirebaseConfig.updatedAtField: FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    if (profile.displayName.isNotEmpty && user != null) {
      await user.updateDisplayName(profile.displayName);
    }

    await _persistLocal(profile);
  }

  Future<void> updateSettings({
    required bool biometricEnabled,
    required String? biometricType,
    required int sessionTimeoutMinutes,
    required int autoLockTimeoutMinutes,
  }) async {
    final uidResult = await _secureStorage.read(key: StorageKeysConfig.userId);
    final uid =
        _auth.currentUser?.uid ?? uidResult.fold((_) => null, (value) => value);
    if (uid == null) return;

    await _users.doc(uid).set(
      {
        FirebaseConfig.settingsField: {
          FirebaseConfig.biometricEnabledField: biometricEnabled,
          FirebaseConfig.biometricTypeField: biometricType,
          FirebaseConfig.sessionTimeoutField: sessionTimeoutMinutes,
          FirebaseConfig.autoLockTimeoutField: autoLockTimeoutMinutes * 60,
        },
        FirebaseConfig.settingsUpdatedAtField: FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Stream<UserSettings?> watchSettings() async* {
    final uidResult = await _secureStorage.read(key: StorageKeysConfig.userId);
    final uid =
        _auth.currentUser?.uid ?? uidResult.fold((_) => null, (value) => value);
    if (uid == null) {
      yield await _localSettings();
      return;
    }

    yield* _users.doc(uid).snapshots().asyncMap((snap) async {
      if (!snap.exists) return await _localSettings();
      final data = snap.data();
      final settings =
          data?[FirebaseConfig.settingsField] as Map<String, dynamic>?;
      if (settings == null) return await _localSettings();
      final parsed = UserSettings.fromMap(settings);
      await _persistLocalSettings(parsed);
      return parsed;
    });
  }

  Future<UserSettings?> fetchSettings() async {
    final uidResult = await _secureStorage.read(key: StorageKeysConfig.userId);
    final uid =
        _auth.currentUser?.uid ?? uidResult.fold((_) => null, (value) => value);
    if (uid == null) return _localSettings();

    final snap = await _users.doc(uid).get();
    if (!snap.exists) return _localSettings();

    final data = snap.data();
    final settings =
        data?[FirebaseConfig.settingsField] as Map<String, dynamic>?;
    if (settings == null) return _localSettings();

    final parsed = UserSettings.fromMap(settings);
    await _persistLocalSettings(parsed);
    return parsed;
  }

  Future<String> uploadAvatar(File file) async {
    final uidResult = await _secureStorage.read(key: StorageKeysConfig.userId);
    final uid =
        _auth.currentUser?.uid ?? uidResult.fold((_) => null, (value) => value);

    if (uid == null) throw Exception('No logged-in user');

    final avatarRef = _storage.ref().child(
        '${FirebaseConfig.avatarStorageFolder}/$uid/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg');

    await avatarRef.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    final downloadUrl = await avatarRef.getDownloadURL();

    await _users.doc(uid).set(
      {
        "${FirebaseConfig.profileField}.${FirebaseConfig.avatarUrlField}":
            downloadUrl,
        FirebaseConfig.updatedAtField: FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await _secureStorage.write(
      key: StorageKeysConfig.avatarUrl,
      value: downloadUrl,
    );

    return downloadUrl;
  }

  Future<UserProfile?> _localProfile() async {
    final firstResult =
        await _secureStorage.read(key: StorageKeysConfig.userFirstName);
    final lastResult =
        await _secureStorage.read(key: StorageKeysConfig.userLastName);
    final emailResult =
        await _secureStorage.read(key: StorageKeysConfig.userEmail);
    final phoneResult =
        await _secureStorage.read(key: StorageKeysConfig.userPhoneNumber);
    final avatarResult =
        await _secureStorage.read(key: StorageKeysConfig.avatarUrl);

    final first = firstResult.fold((_) => null, (value) => value);
    final last = lastResult.fold((_) => null, (value) => value);
    final email = emailResult.fold((_) => null, (value) => value);
    final phone = phoneResult.fold((_) => null, (value) => value);
    final avatar = avatarResult.fold((_) => null, (value) => value);

    if (first == null &&
        last == null &&
        email == null &&
        phone == null &&
        avatar == null) {
      return null;
    }

    return UserProfile(
      firstName: first ?? '',
      lastName: last ?? '',
      email: email ?? '',
      phone: phone ?? '',
      avatarUrl: avatar,
    );
  }

  Future<void> _persistLocal(UserProfile profile) async {
    await _secureStorage.write(
        key: StorageKeysConfig.userFirstName, value: profile.firstName);
    await _secureStorage.write(
        key: StorageKeysConfig.userLastName, value: profile.lastName);
    await _secureStorage.write(
        key: StorageKeysConfig.userEmail, value: profile.email);
    await _secureStorage.write(
        key: StorageKeysConfig.userPhoneNumber, value: profile.phone);
    if (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty) {
      await _secureStorage.write(
          key: StorageKeysConfig.avatarUrl, value: profile.avatarUrl!);
    }
  }

  Future<UserSettings?> _localSettings() async {
    final biometricEnabledResult =
        await _secureStorage.read(key: StorageKeysConfig.biometricEnabled);
    final biometricTypeResult =
        await _secureStorage.read(key: StorageKeysConfig.biometricType);
    final sessionTimeoutResult =
        await _secureStorage.read(key: StorageKeysConfig.sessionTimeoutMinutes);
    final autoLockTimeoutResult = await _secureStorage.read(
        key: StorageKeysConfig.autoLockTimeoutSeconds);
    final avatarPathResult =
        await _secureStorage.read(key: StorageKeysConfig.avatarUrl);

    final biometricEnabled =
        biometricEnabledResult.fold((_) => false, (value) => value == 'true');
    final biometricType =
        biometricTypeResult.fold((_) => null, (value) => value);
    final sessionTimeout = sessionTimeoutResult.fold(
        (_) => 30, (value) => int.tryParse(value ?? '30') ?? 30);
    final autoLockTimeoutSeconds = autoLockTimeoutResult.fold(
      (_) => 120,
      (value) => int.tryParse(value ?? '120') ?? 120,
    );
    final autoLockTimeout = (autoLockTimeoutSeconds / 60).ceil();
    final avatarPath = avatarPathResult.fold((_) => null, (value) => value);

    return UserSettings(
      biometricEnabled: biometricEnabled,
      biometricType: biometricType,
      sessionTimeoutMinutes: sessionTimeout,
      autoLockTimeoutMinutes: autoLockTimeout,
      avatarUrl: avatarPath,
    );
  }

  Future<void> _persistLocalSettings(UserSettings settings) async {
    await _secureStorage.write(
      key: StorageKeysConfig.biometricEnabled,
      value: settings.biometricEnabled.toString(),
    );
    if (settings.biometricType != null) {
      await _secureStorage.write(
        key: StorageKeysConfig.biometricType,
        value: settings.biometricType!,
      );
    }
    await _secureStorage.write(
      key: StorageKeysConfig.sessionTimeoutMinutes,
      value: settings.sessionTimeoutMinutes.toString(),
    );
    await _secureStorage.write(
      key: StorageKeysConfig.autoLockTimeoutSeconds,
      value: (settings.autoLockTimeoutMinutes * 60).toString(),
    );
    if (settings.avatarUrl != null) {
      await _secureStorage.write(
        key: StorageKeysConfig.avatarUrl,
        value: settings.avatarUrl!,
      );
    }
  }

  Future<bool?> getLocalBiometricEnabled() async {
    final result = await _secureStorage.read(key: StorageKeysConfig.biometricEnabled);
    return result.fold(
      (_) => null,
      (value) => value == null ? null : value == 'true',
    );
  }
}
