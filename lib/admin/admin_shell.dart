import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/core.dart';
import '../data/data.dart';
import '../services/admin_api.dart';
import '../services/auth_service.dart';
import 'admin_widgets.dart';

class _Dest {
  final String label, path;
  final IconData icon;
  const _Dest(this.label, this.path, this.icon);
}

const _dests = [
  _Dest('Inquiries', '/admin/inquiries', Icons.inbox_outlined),
  _Dest('Articles', '/admin/articles', Icons.article_outlined),
  _Dest('Team', '/admin/team', Icons.groups_outlined),
];

/// Frame around every admin page: sidebar on desktop, bottom bar on mobile.
class AdminShell extends StatelessWidget {
  final String location;
  final Widget child;
  const AdminShell({super.key, required this.location, required this.child});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: auth,
        builder: (context, _) =>
            auth.status == AuthStatus.signedIn ? _Chrome(location: location, child: child) : const AdminSplash(),
      );
}

class _Chrome extends StatefulWidget {
  final String location;
  final Widget child;
  const _Chrome({required this.location, required this.child});
  @override
  State<_Chrome> createState() => _ChromeState();
}

class _ChromeState extends State<_Chrome> {
  @override
  void initState() {
    super.initState();
    refreshUnreadCount(); // fills the unread badge
  }

  int get _index {
    final i = _dests.indexWhere((d) => widget.location.startsWith(d.path));
    return i < 0 ? 0 : i;
  }

  Future<void> _signOut() => auth.logout(); // the router then moves to the login page

  @override
  Widget build(BuildContext context) {
    final page = ColoredBox(color: context.pal.page, child: widget.child);
    return isMobile(context) ? _mobile(context, page) : _desktop(context, page);
  }

  Widget _mobile(BuildContext context, Widget page) => Scaffold(
        appBar: AppBar(
          backgroundColor: lagoon,
          foregroundColor: Colors.white,
          title: Text(_dests[_index].label, style: serif(26, c: Colors.white)),
          actions: [
            IconButton(tooltip: 'Sign out', icon: const Icon(Icons.logout), onPressed: _signOut),
          ],
        ),
        body: page,
        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: adminUnread,
          builder: (context, unread, _) => NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => context.go(_dests[i].path),
            destinations: [
              for (final d in _dests)
                NavigationDestination(
                  label: d.label,
                  icon: d.path == '/admin/inquiries'
                      ? Badge(isLabelVisible: unread > 0, label: Text('$unread'), child: Icon(d.icon))
                      : Icon(d.icon),
                ),
            ],
          ),
        ),
      );

  Widget _desktop(BuildContext context, Widget page) => Scaffold(
        body: Row(children: [
          Container(
            width: 248,
            color: lagoon,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(firmName, style: serif(24, c: Colors.white)),
                  const SizedBox(height: 4),
                  Text('ADMIN', style: sans(11, c: brass, w: FontWeight.w600).copyWith(letterSpacing: 2)),
                ]),
              ),
              for (var i = 0; i < _dests.length; i++) _SideItem(dest: _dests[i], active: i == _index),
              const Spacer(),
              const Divider(color: Colors.white24, height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
                child: Text(auth.user?.email ?? '',
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: sans(12, c: Colors.white60)),
              ),
              _FooterButton(icon: Icons.logout, label: 'Sign out', onTap: _signOut),
              const SizedBox(height: 12),
            ]),
          ),
          Expanded(child: page),
        ]),
      );
}

class _SideItem extends StatelessWidget {
  final _Dest dest;
  final bool active;
  const _SideItem({required this.dest, required this.active});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => context.go(dest.path),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 14),
          decoration: BoxDecoration(
            color: active ? Colors.white.withOpacity(.08) : null,
            border: Border(left: BorderSide(width: 3, color: active ? brass : Colors.transparent)),
          ),
          child: Row(children: [
            Icon(dest.icon, size: 20, color: active ? brass : Colors.white70),
            const SizedBox(width: 14),
            Expanded(
              child: Text(dest.label,
                  style: sans(15, c: Colors.white, w: active ? FontWeight.w600 : FontWeight.w400)),
            ),
            if (dest.path == '/admin/inquiries')
              ValueListenableBuilder<int>(
                valueListenable: adminUnread,
                builder: (_, n, __) => n == 0
                    ? const SizedBox.shrink()
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                        color: brass,
                        child: Text('$n', style: sans(12, c: deep, w: FontWeight.w700).copyWith(height: 1.5)),
                      ),
              ),
          ]),
        ),
      );
}

class _FooterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _FooterButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Row(children: [
            Icon(icon, size: 18, color: Colors.white70),
            const SizedBox(width: 12),
            Text(label, style: sans(14, c: Colors.white70)),
          ]),
        ),
      );
}