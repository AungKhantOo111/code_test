class User {
  final String id;
  final String phone;
  final String firstName;
  final String? lastName;
  final DateTime dateOfBirth;
  final String tier; // e.g., 'Bronze', 'Silver', 'Gold'
  final int points;

  const User({
    required this.id,
    required this.phone,
    required this.firstName,
    this.lastName,
    required this.dateOfBirth,
    this.tier = 'Bronze',
    this.points = 1290,
  });

  String get fullName =>
      lastName != null && lastName!.isNotEmpty ? '$firstName $lastName' : firstName;

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'tier': tier,
        'points': points,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        phone: json['phone'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String?,
        dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
        tier: json['tier'] as String? ?? 'Bronze',
        points: json['points'] as int? ?? 1290,
      );
}
