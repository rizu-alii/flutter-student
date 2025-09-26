class Course {
  final int id;
  final String name;
  final String code;

  Course({required this.id, required this.name, required this.code});

  // Convert to Map (for SQLite insert/update)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }

  // Create object from Map (when reading from DB)
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      code: map['code'],
    );
  }

  // Create object from API JSON
  factory Course.fromApi(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }
}
