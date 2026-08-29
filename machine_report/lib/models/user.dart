enum UserRole {
  administrator,
  technician;

  String get label => switch (this) {
        UserRole.administrator => 'Administrator',
        UserRole.technician => 'Technician',
      };
}

class User {
  const User({
    required this.username,
    required this.password,
    required this.role,
  });

  final String username;
  final String password;
  final UserRole role;
}
