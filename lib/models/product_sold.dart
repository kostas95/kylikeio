import 'product.dart';

class ProductSold extends Product {
  int? quantity;
  DateTime? date;
  String? productId;

  ProductSold();

  double? get getIncome {
    if (quantity != null && price != null) return (quantity! * price!);
    else return null;
  }

  ProductSold.fromMap(String id, dynamic data) {
    this.id = id;
    // Id of the product that was sold
    this.productId = data["productId"];
    // Name of the product that was sold
    this.name = data["name"];
    this.quantity = data["quantity"];
    this.date = DateTime.parse(data["date"]);
    this.category = data["category"];
    this.price = data["price"];
    this.notes = data["notes"];
  }

  Map<String, dynamic> toMap() => {
        "productId": this.productId,
        "name": this.name,
        "quantity": this.quantity,
        "date": this.date?.toIso8601String(),
        "price": this.price,
        "category": this.category,
        "notes": this.notes,
      };

  @override
  String toString() {
    return 'ProductSold{quantity: $quantity, date: $date, productId: $productId}';
  }
}
