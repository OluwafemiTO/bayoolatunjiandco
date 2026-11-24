import 'package:flutter/material.dart';
import '../core/core.dart';
import '../models/member.dart';
import '../services/admin_api.dart';
import '../widgets/async_view.dart';
import '../widgets/brand_button.dart';
import '../widgets/form_error_banner.dart';
import '../widgets/form_styles.dart';
import 'admin_widgets.dart';

class TeamAdminPage extends StatefulWidget {
  const TeamAdminPage({super.key});
  @override
  State<TeamAdminPage> createState() => _TeamAdminPageState();
}

class _TeamAdminPageState extends State<TeamAdminPage> {
  List<Member>? _members;
  String? _error;
  bool _loading = true;
  final _busy = <String>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final list = await adminApi.team();
      if (!mounted) return;
      setState(() {
        _members = list;
        _loading = false;
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

  Future<void> _edit([Member? member]) async {
    final saved = await showDialog<Member>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _MemberDialog(member: member),
    );
    if (saved == null || !mounted) return;
    showToast(context, member == null ? 'Team member added' : 'Changes saved');
    await _load(silent: true);
  }

  Future<void> _setVisible(Member m, bool visible) async {
    setState(() => _busy.add(m.id));
    try {
      // sends the whole record, so nothing else about the member changes
      final saved = await adminApi.updateMember(
        m.id,
        Member(m.name, m.title, m.credentials, m.initials, m.bio,
            admissions: m.admissions, highlights: m.highlights, imageURL: m.imageURL, visible: visible),
      );
      if (!mounted) return;
      setState(() => _members = [for (final x in _members!) x.id == m.id ? saved : x]);
      showToast(context, visible ? '${m.name} is now shown on the website' : '${m.name} is now hidden');
    } catch (e) {
      if (mounted) showToast(context, errorMessage(e), error: true);
    } finally {
      if (mounted) setState(() => _busy.remove(m.id));
    }
  }

  Future<void> _delete(Member m) async {
    final ok = await confirmDialog(context,
        title: 'Delete team member?',
        message:
            '${m.name} will be permanently deleted. To keep the profile but remove it from the website, hide it instead.');
    if (!ok) return;
    setState(() => _busy.add(m.id));
    try {
      await adminApi.deleteMember(m.id);
      if (!mounted) return;
      setState(() => _members = _members!.where((x) => x.id != m.id).toList());
      showToast(context, 'Team member deleted');
    } catch (e) {
      if (mounted) showToast(context, errorMessage(e), error: true);
    } finally {
      if (mounted) setState(() => _busy.remove(m.id));
    }
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    if (newIndex == oldIndex) return;
    final before = List<Member>.of(_members!);
    final after = List<Member>.of(before);
    after.insert(newIndex, after.removeAt(oldIndex));
    setState(() => _members = after); // shows the new order immediately
    try {
      final saved = await adminApi.reorderTeam([for (final m in after) m.id]);
      if (mounted) setState(() => _members = saved);
    } catch (e) {
      if (!mounted) return;
      setState(() => _members = before); // save failed: put it back
      showToast(context, 'Could not save the new order: ${errorMessage(e)}', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _members;
    return AdminScroll(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AdminPageHeader(
          title: 'Team',
          subtitle: 'Drag to change the order shown on the website. Hidden members stay here but are not shown.',
          actions: [BrandButton('Add member', style: BrandButtonStyle.primary, compact: true, onPressed: () => _edit())],
        ),
        if (_loading && list == null)
          const LoadingPanel()
        else if (_error != null && list == null)
          ErrorPanel(message: _error!, onRetry: _load)
        else if (list != null) ...[
          if (list.isEmpty)
            AdminCard(
              padding: const EdgeInsets.all(32),
              child: Text('No team members yet. Add the first one.',
                  style: sans(15, c: context.pal.text.withOpacity(.7))),
            )
          else
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              onReorder: _onReorder,
              proxyDecorator: (child, _, __) => Material(elevation: 4, color: Colors.transparent, child: child),
              children: [
                for (var i = 0; i < list.length; i++)
                  _MemberRow(
                    key: ValueKey(list[i].id),
                    index: i,
                    m: list[i],
                    busy: _busy.contains(list[i].id),
                    onEdit: () => _edit(list[i]),
                    onVisible: (v) => _setVisible(list[i], v),
                    onDelete: () => _delete(list[i]),
                  ),
              ],
            ),
        ],
      ]),
    );
  }
}

class _MemberRow extends StatelessWidget {
  final int index;
  final Member m;
  final bool busy;
  final VoidCallback onEdit, onDelete;
  final void Function(bool) onVisible;
  const _MemberRow({
    super.key,
    required this.index,
    required this.m,
    required this.busy,
    required this.onEdit,
    required this.onVisible,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AdminCard(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(children: [
          ReorderableDragStartListener(
            index: index,
            child: const MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: Padding(padding: EdgeInsets.all(8), child: Icon(Icons.drag_indicator)),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 44,
            height: 44,
            color: lagoon,
            alignment: Alignment.center,
            child: Text(m.initials, style: serif(20, c: brass, w: FontWeight.w600)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Opacity(
              opacity: m.visible ? 1 : .55,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(m.name,
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: sans(16, c: pal.heading, w: FontWeight.w600)),
                Text(m.titleLine,
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: sans(13, c: pal.text.withOpacity(.7))),
              ]),
            ),
          ),
          if (!m.visible) ...[const SizedBox(width: 8), StatusChip('Hidden', color: brass)],
          Tooltip(
            message: m.visible ? 'Shown on website' : 'Hidden from website',
            child: Switch(value: m.visible, onChanged: busy ? null : onVisible),
          ),
          IconButton(tooltip: 'Edit', onPressed: busy ? null : onEdit, icon: const Icon(Icons.edit_outlined)),
          IconButton(
            tooltip: 'Delete',
            onPressed: busy ? null : onDelete,
            icon: const Icon(Icons.delete_outline, color: Color(0xFFB3261E)),
          ),
        ]),
      ),
    );
  }
}

// Limits enforced by the API.
const _maxShort = 120, _maxInitials = 4, _maxBio = 5000, _maxItem = 300, _maxItems = 20;

/// Add or edit a team member. Saves by itself and closes with the saved member.
class _MemberDialog extends StatefulWidget {
  final Member? member;
  const _MemberDialog({this.member});
  @override
  State<_MemberDialog> createState() => _MemberDialogState();
}

class _MemberDialogState extends State<_MemberDialog> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.member?.name);
  late final _title = TextEditingController(text: widget.member?.title);
  late final _credentials = TextEditingController(text: widget.member?.credentials);
  late final _initials = TextEditingController(text: widget.member?.initials);
  late final _bio = TextEditingController(text: widget.member?.bio);
  late final _admissions = TextEditingController(text: widget.member?.admissions.join('\n'));
  late final _highlights = TextEditingController(text: widget.member?.highlights.join('\n'));
  late final _image = TextEditingController(text: widget.member?.imageURL);
  late bool _visible = widget.member?.visible ?? true;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _title, _credentials, _initials, _bio, _admissions, _highlights, _image]) {
      c.dispose();
    }
    super.dispose();
  }

  List<String> _lines(TextEditingController c) =>
      c.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  String? _required(String? v, int max, String what) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return '$what is required';
    if (t.length > max) return '$what must be $max characters or fewer';
    return null;
  }

  String? _linesOk(TextEditingController c) {
    final l = _lines(c);
    if (l.length > _maxItems) return 'At most $_maxItems lines';
    if (l.any((e) => e.length > _maxItem)) return 'Each line must be $_maxItem characters or fewer';
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

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final image = _image.text.trim();
    final draft = Member(
      _name.text.trim(),
      _title.text.trim(),
      _credentials.text.trim(),
      _initials.text.trim().toUpperCase(), // blank: the API makes them from the name (new members)
      _bio.text.trim(),
      admissions: _lines(_admissions),
      highlights: _lines(_highlights),
      imageURL: image.isEmpty ? null : image,
      visible: _visible,
    );
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final existing = widget.member;
      final saved =
          existing == null ? await adminApi.createMember(draft) : await adminApi.updateMember(existing.id, draft);
      if (mounted) Navigator.of(context).pop(saved);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = errorMessage(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 14);
    return Dialog(
      backgroundColor: context.pal.page,
      shape: const RoundedRectangleBorder(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _form,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
              Text(widget.member == null ? 'Add team member' : 'Edit team member',
                  style: serif(32, c: context.pal.heading)),
              const SizedBox(height: 20),
              if (_error != null) ...[FormErrorBanner(_error!), gap],
              TextFormField(
                controller: _name,
                decoration: inputDecoration(context, 'Name'),
                validator: (v) => _required(v, _maxShort, 'Name'),
              ),
              gap,
              TextFormField(
                controller: _title,
                decoration: inputDecoration(context, 'Title (e.g. Senior Associate)'),
                validator: (v) => _required(v, _maxShort, 'Title'),
              ),
              gap,
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _credentials,
                    decoration: inputDecoration(context, 'Credentials (optional)').copyWith(helperText: 'e.g. LL.B, BL'),
                    validator: (v) => (v ?? '').trim().length > _maxShort ? 'At most $_maxShort characters' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _initials,
                    textCapitalization: TextCapitalization.characters,
                    decoration: inputDecoration(context, 'Initials').copyWith(helperText: 'Blank = from name'),
                    validator: (v) => (v ?? '').trim().length > _maxInitials ? 'At most $_maxInitials' : null,
                  ),
                ),
              ]),
              gap,
              TextFormField(
                controller: _bio,
                minLines: 5,
                maxLines: 12,
                decoration: inputDecoration(context, 'Biography').copyWith(alignLabelWithHint: true),
                validator: (v) => _required(v, _maxBio, 'Biography'),
              ),
              gap,
              TextFormField(
                controller: _admissions,
                minLines: 2,
                maxLines: 6,
                decoration: inputDecoration(context, 'Bar admissions (optional)')
                    .copyWith(helperText: 'One per line.', alignLabelWithHint: true),
                validator: (_) => _linesOk(_admissions),
              ),
              gap,
              TextFormField(
                controller: _highlights,
                minLines: 2,
                maxLines: 6,
                decoration: inputDecoration(context, 'Professional highlights (optional)')
                    .copyWith(helperText: 'One per line.', alignLabelWithHint: true),
                validator: (_) => _linesOk(_highlights),
              ),
              gap,
              TextFormField(
                controller: _image,
                keyboardType: TextInputType.url,
                decoration: inputDecoration(context, 'Portrait image URL (optional)'),
                validator: _url,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Show on the website'),
                value: _visible,
                onChanged: _saving ? null : (v) => setState(() => _visible = v),
              ),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(onPressed: _saving ? null : () => Navigator.of(context).pop(), child: const Text('Cancel')),
                const SizedBox(width: 8),
                BrandButton('Save',
                    style: BrandButtonStyle.primary, compact: true, loading: _saving, onPressed: _saving ? null : _save),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}