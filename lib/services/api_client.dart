import 'dart:async';
import 'dart:convert';

import '../../core/config.dart';
import 'package:http/http.dart' as http;


class FieldError {
  final String field, message;
  const FieldError(this.field, this.message);
}

/// Any failed API call. `status == 0` means the server was never reached.
class ApiException implements Exception {
  final int status;
  final String code, message;
  final List<FieldError> details;
  const ApiException(this.status, this.code, this.message, [this.details = const []]);

  bool get isNetwork => status == 0;
  bool get isNotFound => status == 404;

  /// The message plus any per-field problems, for showing to a person.
  String get fullMessage {
    if (details.isEmpty) return message;
    final parts = [
      for (final d in details) d.field.isEmpty ? d.message : '${d.field}: ${d.message}',
    ];
    return '$message (${parts.join('; ')})';
  }

  @override
  String toString() => 'ApiException($status $code): $message';
}

typedef TokenProvider = String? Function();
typedef UnauthorizedHandler = Future<bool> Function();

/// Thin wrapper over `package:http` that understands the API's response shape:
///   success -> { success: true, data: ... }   (returns `data`)
///   failure -> { success: false, error: { status, code, message, details? } }
class ApiClient {
  ApiClient({http.Client? client, this.token, this.onUnauthorized}) : _http = client ?? http.Client();

  final http.Client _http;

  /// When set, its value is sent as `Authorization: Bearer ...`.
  final TokenProvider? token;

  /// Called once after a 401. Return true if the login was renewed;
  /// the request is then retried with the new token.
  final UnauthorizedHandler? onUnauthorized;

  Future<dynamic> get(String path, {Map<String, Object?>? query}) => send('GET', path, query: query);
  Future<dynamic> post(String path, {Object? body}) => send('POST', path, body: body);
  Future<dynamic> put(String path, {Object? body}) => send('PUT', path, body: body);
  Future<dynamic> patch(String path, {Object? body}) => send('PATCH', path, body: body);
  Future<dynamic> delete(String path) => send('DELETE', path);

  Future<dynamic> send(String method, String path, {Map<String, Object?>? query, Object? body}) async {
    var res = await _once(method, path, query, body);
    if (res.statusCode == 401 && token != null && onUnauthorized != null) {
      if (await onUnauthorized!()) res = await _once(method, path, query, body);
    }
    return _unwrap(res);
  }

  Future<http.Response> _once(String method, String path, Map<String, Object?>? query, Object? body) async {
    final params = {
      if (query != null)
        for (final e in query.entries)
          if (e.value != null) e.key: '${e.value}',
    };
    final uri = Uri.parse('$apiBase$path').replace(queryParameters: params.isEmpty ? null : params);

    final req = http.Request(method, uri)..headers['Accept'] = 'application/json';
    final t = token?.call();
    if (t != null) req.headers['Authorization'] = 'Bearer $t';
    // Fastify rejects a JSON content-type with an empty body, so only set it when there is one.
    if (body != null) {
      req.headers['Content-Type'] = 'application/json';
      req.body = jsonEncode(body);
    }

    try {
      final streamed = await _http.send(req).timeout(const Duration(seconds: 20));
      return await http.Response.fromStream(streamed);
    } on TimeoutException {
      throw const ApiException(0, 'NETWORK', 'The server took too long to respond. Please try again.');
    } catch (_) {
      throw const ApiException(0, 'NETWORK', 'Could not reach the server. Check your connection and try again.');
    }
  }

  dynamic _unwrap(http.Response res) {
    Object? json;
    try {
      if (res.bodyBytes.isNotEmpty) json = jsonDecode(utf8.decode(res.bodyBytes));
    } catch (_) {
      // not JSON (e.g. a proxy error page): handled below
    }

    final ok = res.statusCode >= 200 && res.statusCode < 300;
    if (ok && json is Map && json['success'] == true) return json['data'];

    if (json is Map && json['error'] is Map) {
      final e = json['error'] as Map;
      throw ApiException(
        res.statusCode,
        '${e['code'] ?? 'ERROR'}',
        '${e['message'] ?? 'Request failed'}',
        [
          for (final d in (e['details'] as List? ?? const []))
            if (d is Map) FieldError('${d['field'] ?? ''}', '${d['message'] ?? ''}'),
        ],
      );
    }
    if (res.statusCode == 429) {
      throw const ApiException(429, 'RATE_LIMITED', 'Too many requests. Please try again shortly.');
    }
    throw ApiException(res.statusCode, 'HTTP_ERROR', 'Request failed (${res.statusCode}).');
  }
}

/// Shared client for the public endpoints (no sign-in).
final publicApi = ApiClient();