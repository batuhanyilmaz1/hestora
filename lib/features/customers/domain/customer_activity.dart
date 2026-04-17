enum CustomerActivityType {
  customerCreated('customer_created'),
  noteAdded('note_added'),
  taskLinked('task_linked'),
  propertyMatched('property_matched'),
  propertyShared('property_shared');

  const CustomerActivityType(this.value);

  final String value;

  static CustomerActivityType fromValue(String raw) {
    return CustomerActivityType.values.firstWhere(
      (type) => type.value == raw,
      orElse: () => CustomerActivityType.customerCreated,
    );
  }
}

class CustomerActivity {
  const CustomerActivity({
    required this.id,
    required this.customerId,
    required this.type,
    required this.createdAt,
    this.body,
    this.relatedTaskId,
    this.relatedPropertyId,
    this.metadata = const <String, dynamic>{},
  });

  final String id;
  final String customerId;
  final CustomerActivityType type;
  final DateTime createdAt;
  final String? body;
  final String? relatedTaskId;
  final String? relatedPropertyId;
  final Map<String, dynamic> metadata;

  factory CustomerActivity.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'];
    return CustomerActivity(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      type: CustomerActivityType.fromValue(json['type'] as String? ?? ''),
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      body: json['body'] as String?,
      relatedTaskId: json['related_task_id'] as String?,
      relatedPropertyId: json['related_property_id'] as String?,
      metadata: metadata is Map
          ? Map<String, dynamic>.from(metadata)
          : const <String, dynamic>{},
    );
  }
}
