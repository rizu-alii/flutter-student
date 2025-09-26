class Section {
  final int id;
  final String batch;
  final String program;
  final String sectionNumber;

  Section({
    required this.id,
    required this.batch,
    required this.program,
    required this.sectionNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'batch': batch,
      'program': program,
      'sectionNumber': sectionNumber,
    };
  }

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      id: map['id'],
      batch: map['batch'],
      program: map['program'],
      sectionNumber: map['sectionNumber'],
    );
  }

  factory Section.fromApi(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      batch: json['batch'],
      program: json['program'],
      sectionNumber: json['sectionNumber'],
    );
  }
}
