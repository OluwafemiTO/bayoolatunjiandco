import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/core.dart';
import '../models/article.dart';
import '../services/admin_api.dart';
import '../widgets/async_view.dart';
import '../widgets/brand_button.dart';
import '../widgets/form_error_banner.dart';
import '../widgets/form_styles.dart';
import 'admin_widgets.dart';

// Limits enforced by the API.
const _maxTitle = 200, _maxSummary = 500, _maxSlug = 80;
const _maxHeading = 200, _maxParagraph = 5000, _maxBullet = 1000, _maxItems = 30, _maxSections = 30;

/// The text fields behind one article section.
class _SectionDraft {
  static var _next = 0;
  final int uid = _next++;
  final heading = TextEditingController();
  final paragraphs = TextEditingController();
  final bullets = TextEditingController();

  _SectionDraft();

  _SectionDraft.from(ArticleSection s) {
    heading.text = s.heading ?? '';
    paragraphs.text = s.paragraphs.join('\n\n'); // paragraphs are separated by a blank line
    bullets.text = s.bullets.join('\n'); // one bullet per line
  }

  void dispose() {
    heading.dispose();
    paragraphs.dispose();
    bullets.dispose();
  }

  List<String> get paragraphList => _split(paragraphs.text, RegExp(r'\n\s*\n'));
  List<String> get bulletList => _split(bullets.text, RegExp(r'\n'));

  static List<String> _split(String text, RegExp sep) =>
      text.split(sep).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  ArticleSection toSection() => ArticleSection(
        heading: heading.text.trim().isEmpty ? null : heading.text.trim(),
        paragraphs: paragraphList,
        bullets: bulletList,
      );

  bool get isEmpty => heading.text.trim().isEmpty && paragraphList.isEmpty && bulletList.isEmpty;
}

class ArticleEditorPage extends StatefulWidget {
  /// Null when writing a new article.
  final String? id;
  const ArticleEditorPage({super.key, this.id});
  @override
  State<ArticleEditorPage> createState() => _ArticleEditorPageState();
}

class _ArticleEditorPageState extends State<ArticleEditorPage> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _slug = TextEditingController();
  final _summary = TextEditingController();
  final _image = TextEditingController();
  final _sections = <_SectionDraft>[_SectionDraft()];

  bool _loading = false, _saving = false, _published = false;
  String? _error, _loadError;
  String _loadedSlug = '';

  bool get _isNew => widget.id == null;

  @override
  void initState() {
    super.initState();
    if (!_isNew) _load();
  }

  @override
  void dispose() {
    for (final c in [_title, _slug, _summary, _image]) {
      c.dispose();
    }
    for (final s in _sections) {
      s.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final a = await adminApi.article(widget.id!);
      if (!mounted) return;
      _fill(a);
      setState(() => _loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = errorMessage(e);
      });
    }
  }

  void _fill(Article a) {
    _title.text = a.title;
    _summary.text = a.summary;
    _slug.text = a.slug;
    _loadedSlug = a.slug;
    _image.text = a.imageURL ?? '';
    _published = a.published;
    for (final s in _sections) {
      s.dispose();
    }
    _sections
      ..clear()
      ..addAll(a.sections.isEmpty ? [_SectionDraft()] : a.sections.map(_SectionDraft.from));
  }

  Future<void> _save() async {
    setState(() => _error = null);
    if (!_form.currentState!.validate()) return;

    final sections = [for (final s in _sections) if (!s.isEmpty) s.toSection()];
    if (sections.isEmpty) {
      setState(() => _error = 'Add at least one section with some content.');
      return;
    }

    final slug = _slug.text.trim();
    final image = _image.text.trim();
    final body = <String, dynamic>{
      'title': _title.text.trim(),
      'summary': _summary.text.trim(),
      'sections': [for (final s in sections) s.toJson()],
      'imageURL': image.isEmpty ? null : image, // null clears it
      // blank = the API makes it from the title (new) or keeps the current one (existing)
      if (slug.isNotEmpty && (_isNew || slug != _loadedSlug)) 'slug': slug,
    };

    setState(() => _saving = true);
    try {
      if (_isNew) {
        body['published'] = _published;
        await adminApi.createArticle(body);
        if (!mounted) return;
        showToast(context, _published ? 'Article published' : 'Draft saved');
        context.go('/admin/articles');
      } else {
        final a = await adminApi.updateArticle(widget.id!, body);
        if (!mounted) return;
        _slug.text = a.slug;
        _loadedSlug = a.slug;
        setState(() => _saving = false);
        showToast(context, 'Changes saved');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = errorMessage(e);
      });
    }
  }

  Future<void> _togglePublished() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final a = _published ? await adminApi.unpublishArticle(widget.id!) : await adminApi.publishArticle(widget.id!);
      if (!mounted) return;
      setState(() {
        _published = a.published;
        _saving = false;
      });
      showToast(context, a.published ? 'Published' : 'Moved back to drafts');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = errorMessage(e);
      });
    }
  }

  void _move(int from, int to) {
    if (to < 0 || to >= _sections.length) return;
    setState(() => _sections.insert(to, _sections.removeAt(from)));
  }

  void _remove(int i) => setState(() => _sections.removeAt(i).dispose());

  String? _required(String? v, int max, String what) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return '$what is required';
    if (t.length > max) return '$what must be $max characters or fewer';
    return null;
  }

  String? _url(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return null;
    final u = Uri.tryParse(t);
    return u != null && (u.scheme == 'http' || u.scheme == 'https') && u.host.isNotEmpty
        ? null
        : 'Enter a full http(s) address';
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_loading) {
      content = const LoadingPanel();
    } else if (_loadError != null) {
      content = ErrorPanel(message: _loadError!, onRetry: _load);
    } else {
      content = _formBody(context);
    }
    return AdminScroll(
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: context.pal.heading, padding: EdgeInsets.zero),
              onPressed: () => context.go('/admin/articles'),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('All articles'),
            ),
            const SizedBox(height: 8),
            AdminPageHeader(title: _isNew ? 'New article' : 'Edit article'),
            content,
          ]),
        ),
      ),
    );
  }

  Widget _formBody(BuildContext context) {
    const gap = SizedBox(height: 16);
    return Form(
      key: _form,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (_error != null) ...[FormErrorBanner(_error!), gap],
        TextFormField(
          controller: _title,
          maxLength: _maxTitle,
          decoration: inputDecoration(context, 'Title'),
          validator: (v) => _required(v, _maxTitle, 'Title'),
        ),
        gap,
        TextFormField(
          controller: _summary,
          maxLines: 3,
          maxLength: _maxSummary,
          decoration: inputDecoration(context, 'Summary (shown in the article list)'),
          validator: (v) => _required(v, _maxSummary, 'Summary'),
        ),
        gap,
        TextFormField(
          controller: _slug,
          maxLength: _maxSlug,
          decoration: inputDecoration(context, 'Web address (optional)').copyWith(
            prefixText: '/insights/',
            helperText: _isNew
                ? 'Leave blank to create it from the title.'
                : "Changing this changes the article's public link.",
          ),
        ),
        gap,
        TextFormField(
          controller: _image,
          keyboardType: TextInputType.url,
          decoration: inputDecoration(context, 'Cover image URL (optional)'),
          validator: _url,
        ),
        const SizedBox(height: 32),
        Text('Content', style: serif(32, c: context.pal.heading)),
        const SizedBox(height: 4),
        Text('Each section can have a heading, paragraphs and bullet points. Read time is worked out automatically.',
            style: sans(14, c: context.pal.text.withOpacity(.7))),
        const SizedBox(height: 16),
        for (var i = 0; i < _sections.length; i++) _sectionCard(context, i),
        Align(
          alignment: Alignment.centerLeft,
          child: AdminOutlined('Add section',
              icon: Icons.add,
              onPressed: _sections.length >= _maxSections ? null : () => setState(() => _sections.add(_SectionDraft()))),
        ),
        const SizedBox(height: 32),
        if (_isNew)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Publish immediately'),
            subtitle: const Text('Off saves it as a draft that only you can see.'),
            value: _published,
            onChanged: _saving ? null : (v) => setState(() => _published = v),
          ),
        const SizedBox(height: 8),
        Wrap(spacing: 12, runSpacing: 12, children: [
          BrandButton(_isNew ? (_published ? 'Publish article' : 'Save draft') : 'Save changes',
              style: BrandButtonStyle.primary, loading: _saving, onPressed: _saving ? null : _save),
          if (!_isNew)
            AdminOutlined(_published ? 'Unpublish' : 'Publish',
                icon: _published ? Icons.visibility_off_outlined : Icons.public,
                onPressed: _saving ? null : _togglePublished),
        ]),
        if (!_isNew)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              _published ? 'This article is live on the website.' : 'This article is a draft.',
              style: sans(13, c: context.pal.text.withOpacity(.6)),
            ),
          ),
      ]),
    );
  }

  Widget _sectionCard(BuildContext context, int i) {
    final s = _sections[i];
    return Padding(
      key: ValueKey(s.uid),
      padding: const EdgeInsets.only(bottom: 16),
      child: AdminCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(child: Text('Section ${i + 1}', style: sans(13, c: brass, w: FontWeight.w600))),
            IconButton(
                tooltip: 'Move up',
                onPressed: i == 0 ? null : () => _move(i, i - 1),
                icon: const Icon(Icons.arrow_upward, size: 20)),
            IconButton(
                tooltip: 'Move down',
                onPressed: i == _sections.length - 1 ? null : () => _move(i, i + 1),
                icon: const Icon(Icons.arrow_downward, size: 20)),
            IconButton(
                tooltip: 'Remove section',
                onPressed: _sections.length == 1 ? null : () => _remove(i),
                icon: const Icon(Icons.delete_outline, size: 20)),
          ]),
          const SizedBox(height: 8),
          TextFormField(
            controller: s.heading,
            decoration: inputDecoration(context, 'Heading (optional)'),
            validator: (v) =>
                (v ?? '').trim().length > _maxHeading ? 'Heading must be $_maxHeading characters or fewer' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: s.paragraphs,
            minLines: 4,
            maxLines: 14,
            decoration: inputDecoration(context, 'Paragraphs')
                .copyWith(helperText: 'Separate paragraphs with a blank line.', alignLabelWithHint: true),
            validator: (_) {
              final p = s.paragraphList;
              if (p.length > _maxItems) return 'At most $_maxItems paragraphs per section';
              if (p.any((e) => e.length > _maxParagraph)) return 'Each paragraph must be $_maxParagraph characters or fewer';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: s.bullets,
            minLines: 3,
            maxLines: 12,
            decoration: inputDecoration(context, 'Bullet points')
                .copyWith(helperText: 'One bullet per line.', alignLabelWithHint: true),
            validator: (_) {
              final b = s.bulletList;
              if (b.length > _maxItems) return 'At most $_maxItems bullets per section';
              if (b.any((e) => e.length > _maxBullet)) return 'Each bullet must be $_maxBullet characters or fewer';
              return null;
            },
          ),
        ]),
      ),
    );
  }
}