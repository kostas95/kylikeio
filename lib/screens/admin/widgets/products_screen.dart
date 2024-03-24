import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kylikeio/models/product.dart';
import 'package:kylikeio/repository/products_repository.dart';

class ProductsScreenController extends GetxController {
  final List<Product> products = [];

  @override
  void onInit() {
    products.addAll(generateDummyProducts());

    super.onInit();
  }

  Future addProduct(Product p) async {
    if (p.name != null && p.price != null) {
      await ProductsRepository().addProduct(p);
    }
  }

  Future deleteProduct(String id) async {
    await ProductsRepository().deleteProduct(id);
  }

  List<Product> generateDummyProducts() {
    List<Product> products = [];

    for (int i = 0; i < 20; i++) {
      Product product = Product();
      product.id = 'product_$i';
      product.name = 'Product $i';
      switch (i % 4) {
        case 0:
          product.category = "Καφέδες - Ροφήματα";
          break;
        case 1:
          product.category = "Σφολιάτες - Σάντουιτς";
          break;
        case 2:
          product.category = "Αναψυκτικά";
        case 3:
          product.category = "Chips - Snacks";
        default:
      }
      product.price = (i + 1) * 10.0; // Assuming price increases by 10 for each product
      product.notes = 'Notes for Product $i';
      products.add(product);
    }

    return products;
  }
}

class ProductsScreen extends StatelessWidget {
  final ProductsScreenController _controller = Get.put<ProductsScreenController>(ProductsScreenController());

  ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.all(32),
          child: MaterialButton(
            hoverElevation: 0,
            elevation: 0,
            padding: EdgeInsets.all(16),
            color: Get.theme.primaryColor.withOpacity(0.7),
            child: Text(
              "Προσθήκη Προϊόντος",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              // Open dialog when button is pressed
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  Product p = Product();
                  final RxString cat = "Καφέδες - Ροφήματα".obs;
                  p.category = "Καφέδες - Ροφήματα";
                  return AlertDialog(
                    contentPadding: EdgeInsets.all(4),
                    title: Text('Προσθήκη Προϊόντος'),
                    content: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 512,
                              child: ListTile(
                                title: TextFormField(
                                  onChanged: (v) {
                                    p.name = v;
                                  },
                                ),
                                subtitle: Text("Όνομα Προϊόντος"),
                              ),
                            ),
                            Obx(
                              () => Padding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 16.0,
                                ),
                                child: DropdownButton<String>(
                                  hint: Text("Κατηγορία"),
                                  isExpanded: true,
                                  autofocus: false.obs.value,
                                  value: cat.value,
                                  onChanged: (String? v) {
                                    cat.value = v!;
                                    p.category = v;
                                  },
                                  items: [
                                    "Καφέδες - Ροφήματα",
                                    "Σφολιάτες - Σάντουιτς",
                                    "Αναψυκτικά",
                                    "Chips - Snacks",
                                  ].map(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 512,
                              child: ListTile(
                                title: TextFormField(
                                  onChanged: (v) {
                                    p.price = double.tryParse(v);
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                                    TextInputFormatter.withFunction(
                                      (oldValue, newValue) {
                                        final text = newValue.text;
                                        return text.isEmpty
                                            ? newValue
                                            : double.tryParse(text) == null
                                                ? oldValue
                                                : newValue;
                                      },
                                    ),
                                  ],
                                ),
                                subtitle: Text("Τιμή Προϊόντος"),
                              ),
                            ),
                            SizedBox(
                              width: 512,
                              child: ListTile(
                                title: TextFormField(
                                  onChanged: (v) {
                                    p.notes = v;
                                  },
                                ),
                                subtitle: Text("Σημειώσεις"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actionsAlignment: MainAxisAlignment.spaceBetween,
                    actions: <Widget>[
                      MaterialButton(
                        hoverElevation: 0,
                        elevation: 0,
                        padding: EdgeInsets.all(16),
                        color: Get.theme.primaryColor.withOpacity(0.7),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await _controller.addProduct(p);
                        },
                        child: Text(
                          'Προσθήκη',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      MaterialButton(
                        hoverElevation: 0,
                        elevation: 0,
                        padding: EdgeInsets.all(16),
                        color: Colors.transparent,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Κλείσιμο'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              ProductTable(
                products: _controller.products,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom Table Widget to display products
class ProductTable extends StatelessWidget {
  final List<Product> products;
  final ProductsScreenController _controller = Get.find<ProductsScreenController>();

  ProductTable({required this.products});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: Get.width / 5,
      columns: [
        DataColumn(
          label: Text('Όνομα'),
        ),
        DataColumn(
          label: Text('Κατηγορία'),
        ),
        DataColumn(
          label: Text('Τιμή'),
        ),
        DataColumn(
          label: Text('Σημειώσεις'),
        ),
        DataColumn(
          label: Text(''),
        ),
      ],
      rows: products.map((product) {
        return DataRow(
          cells: [
            DataCell(
              Text(product.name ?? ''),
            ),
            DataCell(
              Text(product.category ?? ''),
            ),
            DataCell(
              Text(product.price?.toString() ?? ''),
            ),
            DataCell(
              Text(product.notes ?? ''),
            ),
            DataCell(
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () async {
                  if (product.id != null) await _controller.deleteProduct(product.id!);
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
