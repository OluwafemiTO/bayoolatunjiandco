import 'package:flutter/foundation.dart';
import '../models/article.dart';
import '../models/inquiry.dart';
import '../models/member.dart';
import 'api_client.dart';
import 'auth_service.dart';

/// Number of unread inquiries, shown as a badge in the admin navigation.
final adminUnread = ValueNotifier<int>(0);

/// Called after a 401: gets a new access token, or ends the session.
Future<bool> _renewSession() async {
  try {
    final ok = await auth.refresh();
    if (!ok) auth.expire();
    return ok;
  } catch (_) {
    return false;
  }
}

class AdminApi {
  final _c = ApiClient(token: () => auth.accessToken, onUnauthorized: _renewSession);

  Map<String, dynamic> _map(Object? v) => v as Map<String, dynamic>;
  List<T> _list<T>(Object? v, T Function(Map<String, dynamic>) f) =>
      [for (final e in v as List) f(e as Map<String, dynamic>)];

  // ── Inquiries ──────────────────────────────────────────────────────────────

  /// GET /admin/inquiries
  Future<InquiryPage> inquiries({bool unreadOnly = false, int page = 1, int perPage = 20}) async {
    final data = _map(await _c.get('/admin/inquiries', query: {
      'unread_only': unreadOnly,
      'page': page,
      'per_page': perPage,
    }));
    final result = InquiryPage.fromJson(data);
    adminUnread.value = result.unreadCount;
    return result;
  }

  /// PATCH /admin/inquiries/:id/read
  Future<Inquiry> markInquiryRead(String id, {bool isRead = true}) async => Inquiry.fromJson(
      _map(_map(await _c.patch('/admin/inquiries/$id/read', body: {'isRead': isRead}))['inquiry']));

  /// DELETE /admin/inquiries/:id
  Future<void> deleteInquiry(String id) => _c.delete('/admin/inquiries/$id');

  // ── Articles ───────────────────────────────────────────────────────────────

  /// GET /admin/articles (drafts included, no bodies)
  Future<List<Article>> articles() async =>
      _list(_map(await _c.get('/admin/articles'))['articles'], Article.fromJson);

  /// GET /admin/articles/:id (with sections, for the edit form)
  Future<Article> article(String id) async =>
      Article.fromJson(_map(_map(await _c.get('/admin/articles/$id'))['article']));

  /// POST /articles
  Future<Article> createArticle(Map<String, dynamic> body) async =>
      Article.fromJson(_map(_map(await _c.post('/articles', body: body))['article']));

  /// PUT /articles/:id
  Future<Article> updateArticle(String id, Map<String, dynamic> body) async =>
      Article.fromJson(_map(_map(await _c.put('/articles/$id', body: body))['article']));

  /// PATCH /articles/:id/publish
  Future<Article> publishArticle(String id) async =>
      Article.fromJson(_map(_map(await _c.patch('/articles/$id/publish'))['article']));

  /// PATCH /articles/:id/unpublish
  Future<Article> unpublishArticle(String id) async =>
      Article.fromJson(_map(_map(await _c.patch('/articles/$id/unpublish'))['article']));

  /// DELETE /articles/:id
  Future<void> deleteArticle(String id) => _c.delete('/articles/$id');

  // ── Team ───────────────────────────────────────────────────────────────────

  /// GET /admin/team (hidden members included)
  Future<List<Member>> team() async => _list(_map(await _c.get('/admin/team'))['team'], Member.fromJson);

  /// POST /team (the new member goes to the end of the list)
  Future<Member> createMember(Member m) async =>
      Member.fromJson(_map(_map(await _c.post('/team', body: m.toJson()))['member']));

  /// PUT /team/:id
  Future<Member> updateMember(String id, Member m) async =>
      Member.fromJson(_map(_map(await _c.put('/team/$id', body: m.toJson()))['member']));

  /// PUT /team/reorder (every member id, in the new order). Returns the saved list.
  Future<List<Member>> reorderTeam(List<String> ids) async =>
      _list(_map(await _c.put('/team/reorder', body: {'ids': ids}))['team'], Member.fromJson);

  /// DELETE /team/:id
  Future<void> deleteMember(String id) => _c.delete('/team/$id');
}

/// Use this everywhere: adminApi.inquiries(), adminApi.team(), ...
final adminApi = AdminApi();

/// Refreshes the unread badge, ignoring errors.
Future<void> refreshUnreadCount() async {
  try {
    await adminApi.inquiries(perPage: 1);
  } catch (_) {}
}