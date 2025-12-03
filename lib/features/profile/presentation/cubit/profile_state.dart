part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile? profile;

  ProfileLoaded(this.profile);
}

class ProfileSaving extends ProfileState {
  final UserProfile profile;

  ProfileSaving(this.profile);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
