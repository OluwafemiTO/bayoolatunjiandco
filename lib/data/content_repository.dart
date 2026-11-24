import '../models/article.dart';
import '../models/member.dart';
import '../services/content_api.dart';

class ContentRepository {
  Future<List<Member>>? _team;
  Future<List<Article>>? _articles;
  final _details = <String, Future<Article>>{};

  Future<List<Member>> team({bool refresh = false}) {
    if (refresh) _team = null;
    return _team ??= _guard(fetchTeam(), () => _team = null);
  }

  Future<List<Article>> articles({bool refresh = false}) {
    if (refresh) _articles = null;
    return _articles ??= _guard(fetchArticles(), () => _articles = null);
  }

  Future<Article> article(String slug, {bool refresh = false}) {
    if (refresh) _details.remove(slug);
    return _details[slug] ??= _guard(fetchArticle(slug), () => _details.remove(slug));
  }

  /// Runs [f]; if it fails, forgets it so the next call tries again.
  Future<T> _guard<T>(Future<T> f, void Function() forget) async {
    try {
      return await f;
    } catch (_) {
      forget();
      rethrow;
    }
  }
}

/// Use this everywhere: content.team(), content.articles(), content.article(slug)
final content = ContentRepository();