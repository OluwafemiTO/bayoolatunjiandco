class Member {
  final String name, title, credentials, initials, bio;
  final List<String> admissions, highlights;
  const Member(this.name, this.title, this.credentials, this.initials, this.bio,
      {this.admissions = const [], this.highlights = const []});

  String get titleLine => [title, if (credentials.isNotEmpty) credentials].join(', ');
}
