import '../models/article.dart';
import '../models/member.dart';
import 'api_client.dart';

/// GET /team: visible members, already in display order.
Future<List<Member>> fetchTeam() async {
  final data = await publicApi.get('/team') as Map<String, dynamic>;
  return [for (final m in data['team'] as List) Member.fromJson(m as Map<String, dynamic>)];
}

/// GET /articles: published articles, newest first. These have no `sections`.
Future<List<Article>> fetchArticles() async {
  final data = await publicApi.get('/articles') as Map<String, dynamic>;
  return [for (final a in data['articles'] as List) Article.fromJson(a as Map<String, dynamic>)];
}

/// GET /articles/:slug: one published article with its full body.
/// Throws ApiException with status 404 if it doesn't exist or isn't published.
Future<Article> fetchArticle(String slug) async {
  final data = await publicApi.get('/articles/${Uri.encodeComponent(slug)}') as Map<String, dynamic>;
  return Article.fromJson(data['article'] as Map<String, dynamic>);
}