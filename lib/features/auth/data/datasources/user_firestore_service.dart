import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_18_final_project/features/auth/data/models/user_model.dart';

/// Handles user profile/settings persistence in Firestore.
class UserFirestoreService {
  UserFirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  /// Upserts basic profile fields under users/{uid}.
  Future<void> upsertProfile({
    required String uid,
    required UserModel user,
  }) {
    return _usersCollection.doc(uid).set(
      {
        'profile': {
          'firstName': user.firstName,
          'lastName': user.lastName,
          'email': user.email,
          'phone': user.phone,
        },
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  /// Upserts app settings (biometrics, timeouts) under users/{uid}.
  Future<void> upsertSettings({
    required String uid,
    required bool biometricEnabled,
    required String? biometricType,
    required int sessionTimeoutMinutes,
    required int autoLockTimeoutMinutes,
  }) {
    return _usersCollection.doc(uid).set(
      {
        'settings': {
          'biometricEnabled': biometricEnabled,
          'biometricType': biometricType,
          'sessionTimeoutMinutes': sessionTimeoutMinutes,
          'autoLockTimeoutMinutes': autoLockTimeoutMinutes,
        },
        'settingsUpdatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  /// Records last login timestamp and device metadata.
  Future<void> recordLogin({
    required String uid,
    required String email,
  }) {
    return _usersCollection.doc(uid).set(
      {
        'security': {
          'lastLoginAt': FieldValue.serverTimestamp(),
          'lastLoginEmail': email,
        },
      },
      SetOptions(merge: true),
    );
  }
}
