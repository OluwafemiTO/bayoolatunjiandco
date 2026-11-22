import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// TODO: set this to your backend URL. While empty, the payload is only
/// printed to the console and the call succeeds (development mode).
const inquiryEndpoint = 'http://localhost:3000/inquiries';

class InquiryPayload {
  final String fullName, email, phone, practiceArea, message;
  const InquiryPayload({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.practiceArea,
    required this.message,
  });

  Map<String, String> toJson() => {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'practiceArea': practiceArea,
        'message': message,
      };
}

/// Throws if the request fails.
Future<void> sendInquiry(InquiryPayload payload) async {
  final json = jsonEncode(payload.toJson());
  if (inquiryEndpoint.isEmpty) {
    debugPrint(json);
    await Future.delayed(const Duration(seconds: 1));
    return;
  }
  final r = await http.post(Uri.parse(inquiryEndpoint),
      headers: {'Content-Type': 'application/json'}, body: json);
  if (r.statusCode < 200 || r.statusCode >= 300) {
    throw Exception('Inquiry failed with status ${r.statusCode}');
  }
}
