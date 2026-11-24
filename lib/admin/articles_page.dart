import '../core/config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/core.dart';
import '../models/article.dart';
import '../services/admin_api.dart';
import '../widgets/async_view.dart';
import '../widgets/brand_button.dart';
import 'admin_format.dart';
import 'admin_widgets.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});
  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  List<Article>? _articles;
  String? _error;
  bool _loading = true;
  final _busy = <String>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await adminApi.articles();
      if (!mounted) return;
      setState(() {
        _articles = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = errorMessage(e);
        _loading = false;
      });
    }
  }

  Future<void> _run(String id, Future<void> Function() action) async {
    setState(() => _busy.add(id));
    try {
      await action();
    } catch (e) {
      if (mounted) showToast(context, errorMessage(e), error: true);
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  Future<void> _setPublished(Article a, bool publish) => _run(a.id, () async {
        final updated = publish ? await adminApi.publishArticle(a.id) : await adminApi.unpublishArticle(a.id);
        if (!mounted) return;
        setState(() => _articles = [for (final x in _articles!) x.id == a.id ? updated : x]);
        showToast(context, publish ? 'Published' : 'Moved back to drafts');
      });

  Future<void> _delete(Article a) async {
    final ok = await confirmDialog(context,
        title: 'Delete article?',
        message: '"${a.title}" will be permanently deleted${a.published ? ' and removed from the website' : ''}.');
    if (!ok) return;
    await _run(a.id, () async {
      await adminApi.deleteArticle(a.id);
      if (!mounted) return;
      setState(() => _articles = _articles!.where((x) => x.id != a.id).toList());
      showToast(context, 'Article deleted');
    });
  }

    // The public site uses hash routes: https://yourdomain.com/#/insights/<slug>
  void _view(Article a) => launchUrl(Uri.parse('$siteUrl/#/insights/${a.slug}'), webOnlyWindowName: '_blank');

  @override
  Widget build(BuildContext context) {
    final list = _articles;
    return AdminScroll(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AdminPageHeader(
          title: 'Articles',
          subtitle: 'Legal insights shown on the website. Drafts are only visible here.',
          actions: [
            BrandButton('New article',
                style: BrandButtonStyle.primary, compact: true, onPressed: () => context.go('/admin/articles/new')),
          ],
        ),
        if (_loading && list == null)
          const LoadingPanel()
        else if (_error != null && list == null)
          ErrorPanel(message: _error!, onRetry: _load)
        else if (list != null) ...[
          if (list.isEmpty)
            AdminCard(
              padding: const EdgeInsets.all(32),
              child: Text('No articles yet. Create the first one.',
                  style: sans(15, c: context.pal.text.withOpacity(.7))),
            )
          else
            for (final a in list)
              _ArticleTile(
                a: a,
                busy: _busy.contains(a.id),
                onEdit: () => context.go('/admin/articles/${a.id}'),
                onTogglePublished: () => _setPublished(a, !a.published),
                onView: () => _view(a),
                onDelete: () => _delete(a),
              ),
        ],
      ]),
    );
  }
}

class _ArticleTile extends StatelessWidget {
  final Article a;
  final bool busy;
  final VoidCallback onEdit, onTogglePublished, onView, onDelete;
  const _ArticleTile({
    required this.a,
    required this.busy,
    required this.onEdit,
    required this.onTogglePublished,
    required this.onView,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AdminCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 10, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
            InkWell(onTap: onEdit, child: Text(a.title, style: serif(24, c: pal.heading))),
            StatusChip(a.published ? 'Published' : 'Draft', color: a.published ? pal.heading : brass),
          ]),
          const SizedBox(height: 6),
          Text(a.summary, maxLines: 2, overflow: TextOverflow.ellipsis, style: sans(14, c: pal.text.withOpacity(.7))),
          const SizedBox(height: 6),
          Text(
            [
              '/insights/${a.slug}',
              '${a.readMinutes} min read',
              if (a.updatedAt != null) 'Updated ${fmtDate(a.updatedAt)}',
              if (a.published && a.publishedAt != null) 'Published ${fmtDate(a.publishedAt)}',
            ].join('  ·  '),
            style: sans(12, c: pal.text.withOpacity(.55)),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            AdminOutlined('Edit', icon: Icons.edit_outlined, onPressed: onEdit),
            AdminOutlined(a.published ? 'Unpublish' : 'Publish',
                icon: a.published ? Icons.visibility_off_outlined : Icons.public,
                onPressed: busy ? null : onTogglePublished),
            if (a.published) AdminOutlined('View', icon: Icons.open_in_new, onPressed: onView),
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: const Color(0xFFB3261E)),
              onPressed: busy ? null : onDelete,
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Delete'),
            ),
          ]),
        ]),
      ),
    );
  }
}