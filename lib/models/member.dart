class Member {
  final String id;
  final String name, title, credentials, initials, bio;
  final List<String> admissions, highlights;
  final String? imageURL;
  final int sortOrder;
  final bool visible;

  const Member(this.name, this.title, this.credentials, this.initials, this.bio,
      {this.admissions = const [],
      this.highlights = const [],
      this.id = '',
      this.imageURL,
      this.sortOrder = 0,
      this.visible = true});

  String get titleLine => [title, if (credentials.isNotEmpty) credentials].join(', ');

  /// Reads one item of `GET /team`.
  factory Member.fromJson(Map<String, dynamic> json) => Member(
        json['name'] as String,
        json['title'] as String,
        (json['credentials'] as String?) ?? '',
        (json['initials'] as String?) ?? '',
        json['bio'] as String,
        admissions: List<String>.from(json['admissions'] as List? ?? const []),
        highlights: List<String>.from(json['highlights'] as List? ?? const []),
        id: json['id'] as String? ?? '',
        imageURL: json['imageURL'] as String?,
        sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
        visible: json['visible'] as bool? ?? true,
      );

  /// Body for `POST /team` and `PUT /team/:id` (admin only).
  /// `initials` is left out when blank, because the API rejects an empty string.
  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'credentials': credentials,
        if (initials.isNotEmpty) 'initials': initials,
        'bio': bio,
        'admissions': admissions,
        'highlights': highlights,
        'imageURL': imageURL,
        'visible': visible,
      };
}