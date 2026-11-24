import 'api_client.dart';

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

/// POST /inquiries. Throws [ApiException] if the request fails.
Future<void> sendInquiry(InquiryPayload payload) => publicApi.post('/inquiries', body: payload.toJson());