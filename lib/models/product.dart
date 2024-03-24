class Product {
  String? id;
  String? name;
  double? price;
  String? notes;

  Product();

  Product.fromMap(Map map) {
    this.id = map["id"];
    this.name = map["name"];
    this.price = map["price"];
    this.notes = map["notes"];
  }

  Map<String, dynamic> toMap() => {
        "id": this.id,
        "name": this.name,
        "price": this.price,
        "notes": this.notes,
      };

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, notes: $notes}';
  }
}
