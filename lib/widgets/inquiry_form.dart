import 'package:flutter/material.dart';
import '../data/data.dart';
import '../services/inquiry_api.dart';
import 'brand_button.dart';
import 'form_error_banner.dart';
import 'form_styles.dart';
import 'inquiry_success.dart';

class InquiryForm extends StatefulWidget {
  const InquiryForm({super.key});
  @override
  State<InquiryForm> createState() => _InquiryFormState();
}

class _InquiryFormState extends State<InquiryForm> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _message = TextEditingController();
  String? _area;
  bool _loading = false, _done = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _email, _phone, _message]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'This field is required' : null;
  String? _validEmail(String? v) =>
      _required(v) ?? (v!.contains('@') && v.contains('.') ? null : 'Enter a valid email address');

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await sendInquiry(InquiryPayload(
        fullName: _name.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        practiceArea: _area!,
        message: _message.text.trim(),
      ));
      if (!mounted) return;
      setState(() {
        _done = true;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'We could not send your inquiry. Please try again or email $firmEmail.';
        _loading = false;
      });
    }
  }

  void _reset() {
    for (final c in [_name, _email, _phone, _message]) {
      c.clear();
    }
    setState(() {
      _done = false;
      _area = null;
    });
  }

  Widget get _gap => const SizedBox(height: 16);

  @override
  Widget build(BuildContext context) {
    if (_done) return InquirySuccess(email: _email.text.trim(), onReset: _reset);
    return Form(
      key: _form,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (_error != null) ...[FormErrorBanner(_error!), _gap],
        TextFormField(controller: _name, decoration: inputDecoration(context, 'Full name'), validator: _required),
        _gap,
        TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: inputDecoration(context, 'Email address'),
            validator: _validEmail),
        _gap,
        TextFormField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: inputDecoration(context, 'Phone number'),
            validator: _required),
        _gap,
        DropdownButtonFormField<String>(
          value: _area,
          isExpanded: true,
          decoration: inputDecoration(context, 'Practice area / legal concern'),
          items: [for (final s in services) DropdownMenuItem(value: s.slug, child: Text(s.title))],
          onChanged: (v) => setState(() => _area = v),
          validator: (v) => v == null ? 'Select a practice area' : null,
        ),
        _gap,
        TextFormField(
            controller: _message,
            maxLines: 5,
            decoration: inputDecoration(context, 'Case summary / inquiry details'),
            validator: _required),
        const SizedBox(height: 20),
        BrandButton('Request a Consultation',
            style: BrandButtonStyle.primary, loading: _loading, onPressed: _loading ? null : _submit),
      ]),
    );
  }
}
