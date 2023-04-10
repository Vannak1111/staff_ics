class Datum1 {
  Datum1({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.classId,
    required this.className,
    required this.campus,
    required this.fullImage,
    required this.version,
  });

  String id;
  String name;
  String email;
  String phone;
  String classId;
  String className;
  String campus;
  String fullImage;
  String version;

  factory Datum1.fromMap(Map<String, dynamic> json) => Datum1(
    id: json["id"].toString(),
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    classId: json["class_id"].toString(),
    className: json["class_name"],
    campus: json["campus"],
    fullImage: json["fullimage"],
    version: json["version"] ?? '',
  );
}