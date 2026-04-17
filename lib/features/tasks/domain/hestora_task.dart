class HestoraTask {
  const HestoraTask({
    required this.id,
    required this.title,
    this.body,
    this.dueAt,
    this.customerId,
    this.propertyId,
    required this.priority,
    required this.status,
    required this.archived,
  });

  final String id;
  final String title;
  final String? body;
  final DateTime? dueAt;
  final String? customerId;
  final String? propertyId;
  final String priority;
  final String status;
  final bool archived;

  factory HestoraTask.fromJson(Map<String, dynamic> json) {
    return HestoraTask(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String?,
      dueAt: json['due_at'] != null ? DateTime.tryParse(json['due_at'] as String) : null,
      customerId: json['customer_id'] as String?,
      propertyId: json['property_id'] as String?,
      priority: json['priority'] as String? ?? 'normal',
      status: json['status'] as String? ?? 'open',
      archived: json['archived'] as bool? ?? false,
    );
  }
}
