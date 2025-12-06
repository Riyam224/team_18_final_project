class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password; // hashed later
  final bool biometricEnabled;

  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.biometricEnabled,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'password': password,
        'biometricEnabled': biometricEnabled,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      biometricEnabled: json['biometricEnabled'] ?? false,
    );
  }
}
