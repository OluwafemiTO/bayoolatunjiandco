import '../data/data.dart';

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

String _two(int n) => n.toString().padLeft(2, '0');

/// "23 Nov 2026"
String fmtDate(DateTime? d) {
  if (d == null) return '';
  final l = d.toLocal();
  return '${l.day} ${_months[l.month - 1]} ${l.year}';
}

/// "23 Nov 2026, 21:17"
String fmtDateTime(DateTime? d) {
  if (d == null) return '';
  final l = d.toLocal();
  return '${fmtDate(l)}, ${_two(l.hour)}:${_two(l.minute)}';
}

/// The contact form saves the practice area's slug; this shows its title instead.
String practiceAreaLabel(String slug) {
  for (final s in services) {
    if (s.slug == slug) return s.title;
  }
  return slug;
}