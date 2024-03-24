import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kylikeio/models/product.dart';
import 'package:kylikeio/repository/products_repository.dart';
import 'package:kylikeio/screens/admin/widgets/product_dialog.dart';

class ProductsScreenController extends GetxController {
  final RxList<Product> products = <Product>[].obs;

  @override
  void onInit() async {
    products.addAll(await getProducts());

    super.onInit();
  }

  Future<List<Product>> getProducts() async {
    return await ProductsRepository().getProducts();
  }

  Future addProduct(Product p) async {
    if (p.name != null && p.price != null) {
      await ProductsRepository().addProduct(p);
      products.insert(0, p);
    }
  }

  Future editProduct(Product p) async {
    if (p.name != null && p.price != null) {
      int index = products.indexWhere((product) => product.id == p.id);
      products.removeAt(index);
      products.insert(index, p);
      await ProductsRepository().editProduct(p);
    }
  }

  Future deleteProduct(String id) async {
    products.removeWhere((product) => product.id == id);
    products.refresh();
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
                  p.category = "Καφέδες - Ροφήματα";
                  return ProductDialog(product: p);
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
  final RxBool _sortAscending = false.obs;
  final RxInt _sortColumnIndex = 0.obs;

  ProductTable({required this.products});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DataTable(
        sortColumnIndex: _sortColumnIndex.value,
        sortAscending: _sortAscending.value,
        showCheckboxColumn: false,
        columnSpacing: Get.mediaQuery.size.width < 1600 ? Get.width / 10 : Get.width / 5,
        columns: [
          DataColumn(
            label: Flexible(child: Text('Όνομα')),
            onSort: (columnIndex, ascending) {
              _sortColumnIndex.value = columnIndex;
              _sortAscending.value = ascending;
              _controller.products.sort(
                (a, b) {
                  if (ascending) {
                    return a.name!.compareTo(b.name!);
                  } else {
                    return b.name!.compareTo(a.name!);
                  }
                },
              );
            },
          ),
          DataColumn(
            label: Flexible(child: Text('Κατηγορία')),
            onSort: (columnIndex, ascending) {
              _sortColumnIndex.value = columnIndex;
              _sortAscending.value = ascending;
              _controller.products.sort(
                    (a, b) {
                  if (ascending) {
                    return a.category!.compareTo(b.category!);
                  } else {
                    return b.category!.compareTo(a.category!);
                  }
                },
              );
            },
          ),
          DataColumn(
            label: Flexible(child: Text('Τιμή')),
            onSort: (columnIndex, ascending) {
              _sortColumnIndex.value = columnIndex;
              _sortAscending.value = ascending;
              _controller.products.sort(
                    (a, b) {
                  if (ascending) {
                    return a.price!.compareTo(b.price!);
                  } else {
                    return b.price!.compareTo(a.price!);
                  }
                },
              );
            },
          ),
          DataColumn(
            label: Flexible(child: Text('Σημειώσεις')),
          ),
          DataColumn(
            label: Text(''),
          ),
        ],
        rows: products.map((product) {
          return DataRow(
            onSelectChanged: (v) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ProductDialog(
                    product: product,
                    editMode: true,
                  );
                },
              );
            },
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
      ),
    );
  }
}
