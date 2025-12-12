import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/features/auth/data/datasources/firebase_user_service.dart';
import 'package:team_18_final_project/features/auth/data/models/user_profile.dart';
import 'package:team_18_final_project/features/auth/data/models/user_settings.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._userService, this._secureStorage)
      : super(ProfileState.initial());

  final FirebaseUserService _userService;
  final ISecureStorage _secureStorage;
  StreamSubscription<UserProfile?>? _profileSub;
  StreamSubscription<UserSettings?>? _settingsSub;

  Future<void> loadUserProfile() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final profile = await _userService.fetchProfile();
      final settings = await _userService.fetchSettings();
      final mergedSettings = await _mergeBiometricFlag(
        settings ?? state.settings,
      );
      await _cacheAvatarPath(profile?.avatarUrl);
      emit(
        state.copyWith(
          isLoading: false,
          profile: profile ?? state.profile,
          settings: mergedSettings,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void startWatching() {
    _profileSub?.cancel();
    _settingsSub?.cancel();

    _profileSub = _userService.watchProfile().listen(
          (profile) async {
            await _cacheAvatarPath(profile?.avatarUrl);
            emit(
              state.copyWith(profile: profile ?? state.profile),
            );
          },
          onError: (e) => emit(state.copyWith(error: e.toString())),
        );

    _settingsSub = _userService.watchSettings().listen(
      (settings) async {
        final merged = await _mergeBiometricFlag(
          settings ?? state.settings,
        );
        emit(state.copyWith(settings: merged));
      },
      onError: (e) => emit(state.copyWith(error: e.toString())),
    );
  }

  Future<void> saveProfileUpdates(UserProfile updated) async {
    emit(state.copyWith(isSaving: true, error: null, profile: updated));
    try {
      await _userService.updateProfile(updated);
      await _cacheAvatarPath(updated.avatarUrl);
      emit(state.copyWith(isSaving: false, profile: updated));
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> updateAvatarAsset(String assetPath) async {
    final updatedProfile = state.profile.copyWith(avatarUrl: assetPath);
    await saveProfileUpdates(updatedProfile);
  }

  Future<void> uploadAvatar(File file) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      final url = await _userService.uploadAvatar(file);
      final updatedProfile = state.profile.copyWith(avatarUrl: url);
      await _userService.updateProfile(updatedProfile);
      await _cacheAvatarPath(updatedProfile.avatarUrl);
      emit(state.copyWith(isSaving: false, profile: updatedProfile));
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> updateBiometricSetting(bool enabled) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      final updatedSettings =
          state.settings.copyWith(biometricEnabled: enabled);
      await _userService.updateSettings(
        biometricEnabled: updatedSettings.biometricEnabled,
        biometricType: updatedSettings.biometricType,
        sessionTimeoutMinutes: updatedSettings.sessionTimeoutMinutes,
        autoLockTimeoutMinutes: updatedSettings.autoLockTimeoutMinutes,
      );
      emit(state.copyWith(isSaving: false, settings: updatedSettings));
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  Future<void> updateAutoLock(int minutes) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      final updatedSettings =
          state.settings.copyWith(autoLockTimeoutMinutes: minutes);
      await _userService.updateSettings(
        biometricEnabled: updatedSettings.biometricEnabled,
        biometricType: updatedSettings.biometricType,
        sessionTimeoutMinutes: updatedSettings.sessionTimeoutMinutes,
        autoLockTimeoutMinutes: updatedSettings.autoLockTimeoutMinutes,
      );
      emit(state.copyWith(isSaving: false, settings: updatedSettings));
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _profileSub?.cancel();
    _settingsSub?.cancel();
    return super.close();
  }

  Future<UserSettings> _mergeBiometricFlag(UserSettings settings) async {
    final localBiometricEnabled = await _userService.getLocalBiometricEnabled();
    if (localBiometricEnabled != null) {
      return settings.copyWith(biometricEnabled: localBiometricEnabled);
    }
    return settings;
  }

  Future<void> _cacheAvatarPath(String? avatarPath) async {
    try {
      if (avatarPath == null || avatarPath.isEmpty) {
        await _secureStorage.delete(key: StorageKeysConfig.avatarUrl);
      } else {
        await _secureStorage.write(
          key: StorageKeysConfig.avatarUrl,
          value: avatarPath,
        );
      }
    } catch (_) {
      // Ignore caching errors; main profile update already succeeded.
    }
  }
}
