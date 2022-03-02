import 'dart:convert';

class DataFields {
  static const String id = "Student ID";
  static const String name = "Student Name";
  // static const String marks = "Marks";
  // static const String result = "Result";

  static List<String> getFields() => [id, name];
}

class Student {
  final int? id;
  final String name;
  final int? marks;

  const Student({this.id, required this.name, this.marks});

  static Student fromJson(Map<String, dynamic> json) => Student(
        id: jsonDecode(json[DataFields.id]),
        name: json[DataFields.name],
        // marks: jsonDecode(json[DataFields.marks]),
      );

  Map<String, dynamic> toJson() => {
        DataFields.id: id,
        DataFields.name: name,
        // DataFields.marks: marks,
      };
}
