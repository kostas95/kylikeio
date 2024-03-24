import 'package:kylikeio/models/product.dart';

class Sales {
  double? earnings;
  List<ProductSold>? productSold;
  DateTime? date;
  String? notes;

  Sales.fromMap(Map map) {
    this.earnings = map["earnings"];
    this.productSold = map["productSold"].map((p) => ProductSold.fromMap(p))?.toList();
    this.date = DateTime.parse(map["dateTime"]);
    this.notes = map["notes"];
  }

  Map toMap() => {
    "earnings": this.earnings,
    "productSold": this.productSold,
    "date": this.date,
    "notes": this.notes,
  };
}

class ProductSold extends Product {
  int? quantity;

  ProductSold.fromMap(map);
}
