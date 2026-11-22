class Member {
  final String name, title, credentials, initials, bio;
  final List<String> admissions, highlights;
  const Member(this.name, this.title, this.credentials, this.initials, this.bio,
      {this.admissions = const [], this.highlights = const []});

  String get titleLine => [title, if (credentials.isNotEmpty) credentials].join(', ');

  /// Reads one item of `GET /team` (extra fields such as id or imageURL are ignored).
  factory Member.fromJson(Map<String, dynamic> json) => Member(
        json['name'] as String,
        json['title'] as String,
        (json['credentials'] as String?) ?? '',
        (json['initials'] as String?) ?? '',
        json['bio'] as String,
        admissions: List<String>.from(json['admissions'] as List? ?? const []),
        highlights: List<String>.from(json['highlights'] as List? ?? const []),
      );

  /// The exact body the admin page sends to `POST /team`.
  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'credentials': credentials,
        'initials': initials,
        'bio': bio,
        'admissions': admissions,
        'highlights': highlights,
      };
}