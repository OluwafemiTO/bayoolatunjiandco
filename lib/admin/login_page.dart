import 'package:flutter/material.dart';
import '../core/core.dart';
import '../data/data.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../widgets/brand_button.dart';
import '../widgets/form_error_banner.dart';
import '../widgets/form_styles.dart';
import 'admin_widgets.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});
  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false, _show = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      // On success the router sees the new session and moves on by itself.
      await auth.login(_email.text, _password.text);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = e.status == 429
            ? 'Too many attempts. Please wait a minute and try again.'
            : e.status == 401
                ? 'Incorrect email or password.'
                : e.fullMessage;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = 'Something went wrong. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: auth,
        builder: (context, _) {
          // still checking the cookie after a reload
          if (auth.status == AuthStatus.unknown) return const AdminSplash();
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Text(firmName, style: serif(30, c: context.pal.heading), textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text('ADMINISTRATION',
                        textAlign: TextAlign.center,
                        style: sans(12, c: brass, w: FontWeight.w600).copyWith(letterSpacing: 2)),
                    const SizedBox(height: 28),
                    AdminCard(
                      padding: const EdgeInsets.all(28),
                      child: AutofillGroup(
                        child: Form(
                          key: _form,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                            Text('Sign in', style: serif(32, c: context.pal.heading)),
                            const SizedBox(height: 20),
                            if (_error != null) ...[FormErrorBanner(_error!), const SizedBox(height: 16)],
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.username, AutofillHints.email],
                              textInputAction: TextInputAction.next,
                              decoration: inputDecoration(context, 'Email address'),
                              validator: (v) => (v == null || !v.contains('@')) ? 'Enter your email address' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _password,
                              obscureText: !_show,
                              autofillHints: const [AutofillHints.password],
                              onFieldSubmitted: (_) => _busy ? null : _submit(),
                              decoration: inputDecoration(context, 'Password').copyWith(
                                suffixIcon: IconButton(
                                  tooltip: _show ? 'Hide password' : 'Show password',
                                  icon: Icon(_show ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                                  onPressed: () => setState(() => _show = !_show),
                                ),
                              ),
                              validator: (v) => (v == null || v.length < 6) ? 'Enter your password' : null,
                            ),
                            const SizedBox(height: 24),
                            BrandButton('Sign in',
                                style: BrandButtonStyle.primary, loading: _busy, onPressed: _busy ? null : _submit),
                          ]),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          );
        },
      );
}