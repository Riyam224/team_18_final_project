class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  String get displayName =>
      [firstName, lastName].where((e) => e.isNotEmpty).join(' ').trim();

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      firstName: (map['firstName'] ?? '') as String,
      lastName: (map['lastName'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
    );
  }
}
