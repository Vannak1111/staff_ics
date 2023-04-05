class CanteenMenu {
  CanteenMenu({
    required this.title,
    required this.subtitle,
  });

  String title;
  String subtitle;

  factory CanteenMenu.fromMap(Map<String, dynamic> json) => CanteenMenu(
    title: json["title"] ?? '',
    subtitle: json["subtitle"] ?? '',
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "subtitle": subtitle,
  };
}