class Instructor {
  final int id;
  final String name;

  Instructor({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Instructor.fromMap(Map<String, dynamic> map) {
    return Instructor(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
    );
  }

  factory Instructor.fromApi(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
