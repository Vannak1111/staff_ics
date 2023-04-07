class ABA {
  ABA({
    required this.amount,
    required this.image,
    required this.link,
  });

  int amount;
  String image;
  String link;

  factory ABA.fromMap(Map<String, dynamic> json) => ABA(
    amount: json["amount"],
    image: json["image"],
    link: json["link"],
  );
}