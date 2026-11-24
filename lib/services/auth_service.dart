import 'package:flutter/foundation.dart';
import 'api_client.dart';
import 'http_client.dart';

enum AuthStatus { unknown, signedOut, signedIn }

class AdminUser {
  final String id, name, email, role;
  const AdminUser({required this.id, required this.name, required this.email, required this.role});

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
        id: json['id'] as String,
        name: (json['name'] as String?) ?? '',
        email: json['email'] as String,
        role: (json['role'] as String?) ?? 'ADMIN',
      );
}

class AuthService extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;
  AdminUser? _user;
  String? _token;
  Future<void>? _restoring;
  Future<bool>? _refreshing;

  late final ApiClient _api = ApiClient(client: createCredentialedClient(), token: () => _token);

  AuthStatus get status => _status;
  AdminUser? get user => _user;
  String? get accessToken => _token;

  /// POST /auth/login. Throws [ApiException] on wrong email or password.
  Future<void> login(String email, String password) async {
    final data = await _api.post('/auth/login', body: {'email': email.trim(), 'password': password})
        as Map<String, dynamic>;
    _token = data['accessToken'] as String;
    _user = AdminUser.fromJson(data['user'] as Map<String, dynamic>);
    _status = AuthStatus.signedIn;
    notifyListeners();
  }

  /// Picks the session back up after a page reload, using the cookie. Safe to call repeatedly.
  Future<void> restore() => _restoring ??= _restore();

  Future<void> _restore() async {
    try {
      if (await refresh()) {
        final me = await _api.get('/me') as Map<String, dynamic>;
        _user = AdminUser.fromJson(me);
        _status = AuthStatus.signedIn;
      } else {
        _status = AuthStatus.signedOut;
      }
    } catch (_) {
      _token = null;
      _status = AuthStatus.signedOut;
    }
    notifyListeners();
  }

  /// POST /auth/refresh. True if there is a new access token, false if the session is over.
  /// Only one refresh can run at a time. A dropped connection is rethrown, so it doesn't sign anyone out.
  Future<bool> refresh() => _refreshing ??= _refresh().whenComplete(() => _refreshing = null);

  Future<bool> _refresh() async {
    try {
      final data = await _api.post('/auth/refresh') as Map<String, dynamic>;
      _token = data['accessToken'] as String;
      return true;
    } on ApiException catch (e) {
      if (e.status == 401) {
        _token = null;
        return false;
      }
      rethrow;
    }
  }

  /// The session is over (the refresh was rejected): the app returns to the login page.
  void expire() {
    if (_status == AuthStatus.signedOut) return;
    _token = null;
    _user = null;
    _status = AuthStatus.signedOut;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _api.post('/auth/logout');
    } catch (_) {
      // the local session is cleared either way
    }
    _token = null;
    _user = null;
    _status = AuthStatus.signedOut;
    notifyListeners();
  }
}

/// Use this everywhere: auth.login(...), auth.status, auth.logout()
final auth = AuthService();