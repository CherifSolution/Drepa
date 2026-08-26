class Crisis {
  final String? id;
  final String userId;
  final int painLevel;
  final String bodyZone;
  final List<String> symptoms;
  final List<String> treatments;
  final DateTime createdAt;

  Crisis({
    this.id,
    required this.userId,
    required this.painLevel,
    required this.bodyZone,
    required this.symptoms,
    required this.treatments,
    required this.createdAt,
  });

  factory Crisis.fromJson(Map<String, dynamic> json) {
    return Crisis(
      id: json['id'],
      userId: json['user_id'],
      painLevel: json['pain_level'],
      bodyZone: json['body_zone'],
      symptoms: List<String>.from(json['symptoms'] ?? []),
      treatments: List<String>.from(json['treatments'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'pain_level': painLevel,
      'body_zone': bodyZone,
      'symptoms': symptoms,
      'treatments': treatments,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
