class PosUserData {
  PosUserData({
    required this.id,
    required this.name,
    required this.cardId,
    required this.balanceCard,
    required this.campus,
    required this.purchaseLimit,
    required this.cardNo,
  });

  int id;
  String name;
  String cardId;
  double balanceCard;
  String campus;
  double purchaseLimit;
  String cardNo;

  factory PosUserData.fromMap(Map<String, dynamic> json) => PosUserData(
    id: json["id"],
    name: json["name"],
    cardId: json["card_id"],
    balanceCard: json["balance_card"],
    campus: json["campus"],
    purchaseLimit: json["purchase_limit"],
    cardNo: json["card_no"] ?? "",
  );
}