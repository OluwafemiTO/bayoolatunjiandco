class ArticleSection {
  final String? heading;
  final List<String> paragraphs, bullets;
  const ArticleSection({this.heading, this.paragraphs = const [], this.bullets = const []});

  factory ArticleSection.fromJson(Map<String, dynamic> json) => ArticleSection(
        heading: json['heading'] as String?,
        paragraphs: List<String>.from(json['paragraphs'] as List? ?? const []),
        bullets: List<String>.from(json['bullets'] as List? ?? const []),
      );

  /// The API rejects an empty heading, so it is left out when blank.
  Map<String, dynamic> toJson() => {
        if (heading != null && heading!.trim().isNotEmpty) 'heading': heading!.trim(),
        'paragraphs': paragraphs,
        'bullets': bullets,
      };
}

// class Article {
//   final String slug, title, summary;
//   final int readMinutes;
//   final bool published;
//   final List<ArticleSection> sections;
//   const Article({
//     required this.slug,
//     required this.title,
//     required this.summary,
//     required this.readMinutes,
//     required this.sections,
//     this.published = true,
//   });
// }


class Article {
  /// Empty only for an article that has not been saved yet.
  final String id;
  final String slug, title, summary;
  final int readMinutes;
  final bool published;
  final String? imageURL;
  final DateTime? publishedAt, updatedAt;

  /// Empty for list items: only the single-article endpoints return the body.
  final List<ArticleSection> sections;

  const Article({
    this.id = '',
    required this.slug,
    required this.title,
    required this.summary,
    this.readMinutes = 1,
    this.sections = const [],
    this.published = true,
    this.imageURL,
    this.publishedAt,
    this.updatedAt,
  });

  /// Reads an item of `GET /articles` / `GET /admin/articles` or the `article`
  /// of the single-article endpoints.
  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json['id'] as String? ?? '',
        slug: json['slug'] as String,
        title: json['title'] as String,
        summary: json['summary'] as String,
        readMinutes: (json['readMinutes'] as num?)?.toInt() ?? 1,
        published: json['published'] as bool? ?? true,
        imageURL: json['imageURL'] as String?,
        publishedAt: _date(json['publishedAt']),
        updatedAt: _date(json['updatedAt']),
        sections: [
          for (final s in json['sections'] as List? ?? const []) ArticleSection.fromJson(s as Map<String, dynamic>),
        ],
      );

  static DateTime? _date(Object? v) => v is String ? DateTime.tryParse(v) : null;
}
