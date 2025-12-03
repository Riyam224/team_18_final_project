import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/features/auth/data/datasources/firebase_user_service.dart';
import 'package:team_18_final_project/features/auth/data/models/user_profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._userService) : super(ProfileInitial());

  final FirebaseUserService _userService;
  StreamSubscription<UserProfile?>? _sub;

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await _userService.fetchProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void startWatching() {
    _sub?.cancel();
    _sub = _userService.watchProfile().listen(
          (profile) => emit(ProfileLoaded(profile)),
          onError: (e) => emit(ProfileError(e.toString())),
        );
  }

  Future<void> updateProfile(UserProfile profile) async {
    emit(ProfileSaving(profile));
    try {
      await _userService.updateProfile(profile);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
