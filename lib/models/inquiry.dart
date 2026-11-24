class Inquiry {
  final String id, fullName, email, phone, practiceArea, message;
  final bool isRead, emailSent;
  final DateTime createdAt;

  const Inquiry({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.practiceArea,
    required this.message,
    required this.isRead,
    required this.emailSent,
    required this.createdAt,
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) => Inquiry(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        practiceArea: json['practiceArea'] as String,
        message: json['message'] as String,
        isRead: json['isRead'] as bool? ?? false,
        emailSent: json['emailSent'] as bool? ?? false,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
}

/// One page of GET /admin/inquiries.
class InquiryPage {
  final List<Inquiry> inquiries;
  final int total, unreadCount, page, perPage;
  const InquiryPage(this.inquiries, this.total, this.unreadCount, this.page, this.perPage);

  factory InquiryPage.fromJson(Map<String, dynamic> json) => InquiryPage(
        [for (final i in json['inquiries'] as List) Inquiry.fromJson(i as Map<String, dynamic>)],
        (json['total'] as num).toInt(),
        (json['unreadCount'] as num).toInt(),
        (json['page'] as num).toInt(),
        (json['perPage'] as num).toInt(),
      );

  int get pages => total == 0 ? 1 : (total / perPage).ceil();
}