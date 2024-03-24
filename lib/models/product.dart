class Product {
  String? id;
  String? name;
  String? category;
  double? price;
  String? notes;

  Product();

  Product.fromMap(Map map) {
    this.id = map["id"];
    this.name = map["name"];
    this.category = map["category"];
    this.price = map["price"];
    this.notes = map["notes"];
  }

  Map<String, dynamic> toMap() => {
        "name": this.name,
        "price": this.price,
        "category": this.category,
        "notes": this.notes,
      };

  @override
  String toString() {
    return 'Product{id: $id, name: $name, category: $category, price: $price, notes: $notes}';
  }
}
