part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final bool isSaving;
  final UserProfile profile;
  final UserSettings settings;
  final String? error;

  const ProfileState({
    required this.isLoading,
    required this.isSaving,
    required this.profile,
    required this.settings,
    this.error,
  });

  factory ProfileState.initial() => ProfileState(
        isLoading: false,
        isSaving: false,
        profile: const UserProfile(
          firstName: '',
          lastName: '',
          email: '',
          phone: '',
        ),
        settings: const UserSettings(
          biometricEnabled: false,
          biometricType: null,
          sessionTimeoutMinutes: 30,
          autoLockTimeoutMinutes: 5,
        ),
      );

  ProfileState copyWith({
    bool? isLoading,
    bool? isSaving,
    UserProfile? profile,
    UserSettings? settings,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      profile: profile ?? this.profile,
      settings: settings ?? this.settings,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSaving, profile, settings, error];
}
