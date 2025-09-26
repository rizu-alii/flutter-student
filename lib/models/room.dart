class Room {
  final int id;
  final String name;

  Room({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'],
      name: map['name'],
    );
  }

  factory Room.fromApi(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
    );
  }
}
