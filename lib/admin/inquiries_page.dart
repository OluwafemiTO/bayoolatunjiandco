import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/core.dart';
import '../models/inquiry.dart';
import '../services/admin_api.dart';
import '../widgets/async_view.dart';
import 'admin_format.dart';
import 'admin_widgets.dart';

class InquiriesPage extends StatefulWidget {
  const InquiriesPage({super.key});
  @override
  State<InquiriesPage> createState() => _InquiriesPageState();
}

class _InquiriesPageState extends State<InquiriesPage> {
  InquiryPage? _data;
  String? _error;
  bool _loading = true, _unreadOnly = false;
  int _page = 1;
  String? _open; // id of the expanded inquiry
  final _busy = <String>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// [silent] keeps the list on screen while refreshing (used after an action).
  Future<void> _load({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      var data = await adminApi.inquiries(unreadOnly: _unreadOnly, page: _page);
      // the last item on the last page was deleted: step back one page
      if (data.inquiries.isEmpty && _page > 1) {
        _page = data.pages;
        data = await adminApi.inquiries(unreadOnly: _unreadOnly, page: _page);
      }
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      if (silent) {
        showToast(context, errorMessage(e), error: true);
      } else {
        setState(() {
          _error = errorMessage(e);
          _loading = false;
        });
      }
    }
  }

  Future<void> _run(String id, Future<void> Function() action, {String? done}) async {
    setState(() => _busy.add(id));
    try {
      await action();
      if (!mounted) return;
      if (done != null) showToast(context, done);
      await _load(silent: true);
    } catch (e) {
      if (mounted) showToast(context, errorMessage(e), error: true);
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  void _toggle(Inquiry q) {
    final opening = _open != q.id;
    setState(() => _open = opening ? q.id : null);
    // opening an unread inquiry marks it as read, like an inbox
    if (opening && !q.isRead) _run(q.id, () => adminApi.markInquiryRead(q.id));
  }

  Future<void> _delete(Inquiry q) async {
    final ok = await confirmDialog(context,
        title: 'Delete inquiry?', message: 'The inquiry from ${q.fullName} will be permanently deleted.');
    if (!ok) return;
    await _run(q.id, () => adminApi.deleteInquiry(q.id), done: 'Inquiry deleted');
  }

  void _setFilter(bool unreadOnly) {
    if (unreadOnly == _unreadOnly) return;
    setState(() {
      _unreadOnly = unreadOnly;
      _page = 1;
      _open = null;
    });
    _load();
  }

  void _goTo(int page) {
    setState(() {
      _page = page;
      _open = null;
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    return AdminScroll(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AdminPageHeader(
          title: 'Inquiries',
          subtitle: 'Consultation requests from the contact form.',
          actions: [AdminOutlined('Refresh', icon: Icons.refresh, onPressed: _loading ? null : () => _load())],
        ),
        SegmentedButton<bool>(
          showSelectedIcon: false,
          segments: [
            const ButtonSegment(value: false, label: Text('All')),
            ButtonSegment(value: true, label: Text(data == null ? 'Unread' : 'Unread (${data.unreadCount})')),
          ],
          selected: {_unreadOnly},
          onSelectionChanged: (s) => _setFilter(s.first),
        ),
        const SizedBox(height: 20),
        if (_loading && data == null)
          const LoadingPanel()
        else if (_error != null && data == null)
          ErrorPanel(message: _error!, onRetry: () => _load())
        else if (data != null) ...[
          if (data.inquiries.isEmpty)
            AdminCard(
              padding: const EdgeInsets.all(32),
              child: Text(_unreadOnly ? 'No unread inquiries.' : 'No inquiries yet.',
                  style: sans(15, c: context.pal.text.withOpacity(.7))),
            )
          else
            for (final q in data.inquiries)
              _InquiryTile(
                q: q,
                open: _open == q.id,
                busy: _busy.contains(q.id),
                onToggle: () => _toggle(q),
                onToggleRead: () => _run(q.id, () => adminApi.markInquiryRead(q.id, isRead: !q.isRead)),
                onDelete: () => _delete(q),
              ),
          if (data.pages > 1) _Pager(page: data.page, pages: data.pages, total: data.total, onGo: _goTo),
        ],
      ]),
    );
  }
}

class _InquiryTile extends StatelessWidget {
  final Inquiry q;
  final bool open, busy;
  final VoidCallback onToggle, onToggleRead, onDelete;
  const _InquiryTile({
    required this.q,
    required this.open,
    required this.busy,
    required this.onToggle,
    required this.onToggleRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: pal.surface,
        border: Border(
          // a brass bar on the left marks an unread inquiry
          left: BorderSide(width: 3, color: q.isRead ? Colors.transparent : brass),
          top: BorderSide(color: pal.text.withOpacity(.12)),
          right: BorderSide(color: pal.text.withOpacity(.12)),
          bottom: BorderSide(color: pal.text.withOpacity(.12)),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Wrap(spacing: 10, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
                    Text(q.fullName,
                        style: sans(16, c: pal.heading, w: q.isRead ? FontWeight.w500 : FontWeight.w700)),
                    StatusChip(practiceAreaLabel(q.practiceArea), color: pal.heading),
                  ]),
                  if (!open) ...[
                    const SizedBox(height: 4),
                    Text(q.message,
                        maxLines: 1, overflow: TextOverflow.ellipsis, style: sans(14, c: pal.text.withOpacity(.7))),
                  ],
                ]),
              ),
              const SizedBox(width: 12),
              Text(fmtDate(q.createdAt), style: sans(13, c: pal.text.withOpacity(.6))),
              Icon(open ? Icons.expand_less : Icons.expand_more, color: pal.text.withOpacity(.6)),
            ]),
          ),
        ),
        if (open)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Divider(height: 1),
              const SizedBox(height: 16),
              Wrap(spacing: 40, children: [
                LabelledValue('Email', q.email),
                LabelledValue('Phone', q.phone),
                LabelledValue('Received', fmtDateTime(q.createdAt)),
              ]),
              LabelledValue('Message', q.message),
              if (!q.emailSent)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('No notification email was sent for this inquiry.',
                      style: sans(12, c: pal.text.withOpacity(.6))),
                ),
              const SizedBox(height: 6),
              Wrap(spacing: 8, runSpacing: 8, children: [
                AdminOutlined('Reply by email',
                    icon: Icons.mail_outline,
                    onPressed: () => launchUrl(Uri.parse(
                        'mailto:${q.email}?subject=${Uri.encodeComponent("Re: your consultation request")}'))),
                AdminOutlined('Call',
                    icon: Icons.call_outlined,
                    onPressed: () => launchUrl(Uri.parse('tel:${q.phone.replaceAll(RegExp(r"[^0-9+]"), "")}'))),
                AdminOutlined(q.isRead ? 'Mark as unread' : 'Mark as read',
                    icon: q.isRead ? Icons.mark_email_unread_outlined : Icons.done,
                    onPressed: busy ? null : onToggleRead),
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: const Color(0xFFB3261E)),
                  onPressed: busy ? null : onDelete,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Delete'),
                ),
              ]),
            ]),
          ),
      ]),
    );
  }
}

class _Pager extends StatelessWidget {
  final int page, pages, total;
  final void Function(int) onGo;
  const _Pager({required this.page, required this.pages, required this.total, required this.onGo});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
              tooltip: 'Previous page',
              onPressed: page > 1 ? () => onGo(page - 1) : null,
              icon: const Icon(Icons.chevron_left)),
          Text('Page $page of $pages  ·  $total inquiries', style: sans(14, c: context.pal.text.withOpacity(.75))),
          IconButton(
              tooltip: 'Next page',
              onPressed: page < pages ? () => onGo(page + 1) : null,
              icon: const Icon(Icons.chevron_right)),
        ]),
      );
}