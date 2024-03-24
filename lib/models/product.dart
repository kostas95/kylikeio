class ProductCategories {
  static final String coffee = "Καφέδες - Ροφήματα";
  static final String sandwich = "Σφολιάτες - Σάντουιτς";
  static final String drinks = "Αναψυκτικά";
  static final String snacks = "Chips - Snacks";
}

class Product {
  String? id;
  String? name;
  String? category;
  double? price;
  String? notes;
  int? availableAmount;
  bool active = true;

  Product();

  Product.fromMap(String id, dynamic data) {
    this.id = id;
    this.name = data["name"];
    this.category = data["category"];
    this.price = data["price"];
    this.notes = data["notes"];
    this.availableAmount = data["amountAvailable"];
    this.active = data["active"] ?? true;
  }

  Map<String, dynamic> toMap() => {
        "name": this.name,
        "price": this.price,
        "category": this.category,
        "notes": this.notes,
        "amountAvailable": this.availableAmount,
        "active": this.active,
      };

  @override
  String toString() {
    return 'Product{id: $id, name: $name, category: $category, price: $price, notes: $notes, availableAmount: $availableAmount, active: $active}';
  }
}
