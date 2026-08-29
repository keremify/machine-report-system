import '../models/user.dart';

class AuthService {
  static final AuthService instance = AuthService._();

  AuthService._() {
    _users.addAll([
      const User(
        username: 'admin',
        password: 'admin123',
        role: UserRole.administrator,
      ),
      const User(
        username: 'tech',
        password: 'tech123',
        role: UserRole.technician,
      ),
    ]);
  }

  final List<User> _users = [];
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isAdmin => _currentUser?.role == UserRole.administrator;

  User? login(String username, String password) {
    for (final user in _users) {
      if (user.username == username && user.password == password) {
        _currentUser = user;
        return user;
      }
    }
    return null;
  }

  void logout() {
    _currentUser = null;
  }
}
