import 'product.dart';

class ProductSold extends Product {
  int? quantity;
  DateTime? date;

  ProductSold();

  ProductSold.fromMap(String id, dynamic data) {
    this.id = id;
    this.name = data["name"];
    this.quantity = data["quantity"];
    this.date = DateTime.parse(data["date"]);
    this.category = data["category"];
    this.price = data["price"];
    this.notes = data["notes"];
  }

  Map<String, dynamic> toMap() => {
    "name": this.name,
    "quantity": this.quantity,
    "date": this.date?.toIso8601String(),
    "price": this.price,
    "category": this.category,
    "notes": this.notes,
  };

  @override
  String toString() {
    return 'ProductSold{quantity: $quantity, date: $date}';
  }
}