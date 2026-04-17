class RedirectLink {
  const RedirectLink({
    required this.id,
    required this.shortCode,
    required this.targetUrl,
    required this.clickCount,
  });

  final String id;
  final String shortCode;
  final String targetUrl;
  final int clickCount;

  factory RedirectLink.fromJson(Map<String, dynamic> json) {
    return RedirectLink(
      id: json['id'] as String,
      shortCode: json['short_code'] as String,
      targetUrl: json['target_url'] as String,
      clickCount: json['click_count'] as int? ?? 0,
    );
  }
}
