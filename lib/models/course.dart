class Course {
  final int id;
  final String name;
  final String code;

  Course({required this.id, required this.name, required this.code});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      code: map['code'] ?? '',
    );
  }

  factory Course.fromApi(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}
