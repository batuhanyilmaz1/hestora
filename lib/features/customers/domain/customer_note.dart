class CustomerNote {
  const CustomerNote({
    required this.id,
    required this.customerId,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String customerId;
  final String body;
  final DateTime createdAt;

  factory CustomerNote.fromJson(Map<String, dynamic> json) {
    return CustomerNote(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      body: json['body'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
