class Day {
  final int id;
  final String name;

  Day({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Day.fromMap(Map<String, dynamic> map) {
    return Day(
      id: map['id'],
      name: map['name'],
    );
  }

  factory Day.fromApi(Map<String, dynamic> json) {
    return Day(
      id: json['id'],
      name: json['name'],
    );
  }
}
