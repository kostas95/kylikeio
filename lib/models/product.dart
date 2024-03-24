class Product {
  String? id;
  String? name;
  String? category;
  double? price;
  String? notes;
  int? availableAmount;

  Product();

  Product.fromMap(String id, dynamic data) {
    this.id = id;
    this.name = data["name"];
    this.category = data["category"];
    this.price = data["price"];
    this.notes = data["notes"];
    this.availableAmount = data["amountAvailable"];
  }

  Map<String, dynamic> toMap() => {
        "name": this.name,
        "price": this.price,
        "category": this.category,
        "notes": this.notes,
        "amountAvailable": this.availableAmount,
      };

  @override
  String toString() {
    return 'Product{id: $id, name: $name, category: $category, price: $price, notes: $notes, amountAvailable: $availableAmount}';
  }
}
