class ItemCard {
  int id;
  // String name;
  String code;
  String dateTime;
  int quantity;
  bool isSelected;

  ItemCard({
    required this.id,
    // required this.name,
    required this.code,
    required this.dateTime,
    required this.quantity,
    this.isSelected = false,
  });
}
