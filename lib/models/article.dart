class ArticleSection {
  final String? heading;
  final List<String> paragraphs, bullets;
  const ArticleSection({this.heading, this.paragraphs = const [], this.bullets = const []});
}

class Article {
  final String slug, title, summary;
  final int readMinutes;
  final bool published;
  final List<ArticleSection> sections;
  const Article({
    required this.slug,
    required this.title,
    required this.summary,
    required this.readMinutes,
    required this.sections,
    this.published = true,
  });
}
