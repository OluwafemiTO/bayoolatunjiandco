import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/core.dart';
import 'form_styles.dart';

class Country {
  final String iso, name, dial;
  const Country(this.iso, this.name, this.dial);

  /// Flag emoji built from the two-letter country code.
  String get flag => String.fromCharCodes(iso.toUpperCase().codeUnits.map((c) => 0x1F1E6 + c - 0x41));
}

// Add or remove countries here. The first one is the default.
const countries = <Country>[
  Country('NG', 'Nigeria', '+234'),
  Country('GH', 'Ghana', '+233'),
  Country('KE', 'Kenya', '+254'),
  Country('ZA', 'South Africa', '+27'),
  Country('UG', 'Uganda', '+256'),
  Country('TZ', 'Tanzania', '+255'),
  Country('SN', 'Senegal', '+221'),
  Country('CI', "Côte d'Ivoire", '+225'),
  Country('CM', 'Cameroon', '+237'),
  Country('EG', 'Egypt', '+20'),
  Country('ET', 'Ethiopia', '+251'),
  Country('RW', 'Rwanda', '+250'),
  Country('GB', 'United Kingdom', '+44'),
  Country('US', 'United States', '+1'),
  Country('CA', 'Canada', '+1'),
  Country('IE', 'Ireland', '+353'),
  Country('DE', 'Germany', '+49'),
  Country('FR', 'France', '+33'),
  Country('NL', 'Netherlands', '+31'),
  Country('ES', 'Spain', '+34'),
  Country('IT', 'Italy', '+39'),
  Country('AE', 'United Arab Emirates', '+971'),
  Country('SA', 'Saudi Arabia', '+966'),
  Country('QA', 'Qatar', '+974'),
  Country('IN', 'India', '+91'),
  Country('PK', 'Pakistan', '+92'),
  Country('CN', 'China', '+86'),
  Country('JP', 'Japan', '+81'),
  Country('SG', 'Singapore', '+65'),
  Country('AU', 'Australia', '+61'),
  Country('NZ', 'New Zealand', '+64'),
  Country('BR', 'Brazil', '+55'),
];

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final Country country;
  final ValueChanged<Country> onCountryChanged;

  const PhoneField({
    super.key,
    required this.controller,
    required this.country,
    required this.onCountryChanged,
  });

  static String _digits(String input) => input.replaceAll(RegExp(r'\D'), '').replaceFirst(RegExp(r'^0+'), '');

  /// The full number to send to the API, e.g. "0803 123 4567" + Nigeria -> "+2348031234567".
  /// A leading 0 is dropped, because it is only used when dialling inside the country.
  static String compose(Country country, String input) => '${country.dial}${_digits(input)}';

  String? _validate(String? v) {
    if (v == null || v.trim().isEmpty) return 'This field is required';
    final n = _digits(v).length;
    return (n < 6 || n > 14) ? 'Enter a valid phone number' : null;
  }

  Future<void> _pick(BuildContext context) async {
    final picked = await showDialog<Country>(context: context, builder: (_) => _CountryPicker(selected: country));
    if (picked != null) onCountryChanged(picked);
  }

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]'))],
        validator: _validate,
        decoration: inputDecoration(context, 'Phone number').copyWith(
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          prefixIcon: InkWell(
            onTap: () => _pick(context),
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 4),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(country.flag, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 6),
                Text(country.dial, style: sans(15, c: context.pal.text)),
                const Icon(Icons.arrow_drop_down),
              ]),
            ),
          ),
        ),
      );
}

class _CountryPicker extends StatefulWidget {
  final Country selected;
  const _CountryPicker({required this.selected});
  @override
  State<_CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<_CountryPicker> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final q = _q.trim().toLowerCase();
    final list = countries.where((c) => c.name.toLowerCase().contains(q) || c.dial.contains(q)).toList();
    return Dialog(
      backgroundColor: context.pal.page,
      shape: const RoundedRectangleBorder(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 480),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              autofocus: true,
              decoration: inputDecoration(context, 'Search country or code').copyWith(prefixIcon: const Icon(Icons.search)),
              onChanged: (v) => setState(() => _q = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) {
                final c = list[i];
                return ListTile(
                  selected: c.iso == widget.selected.iso,
                  leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
                  title: Text(c.name),
                  trailing: Text(c.dial),
                  onTap: () => Navigator.of(context).pop(c),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}