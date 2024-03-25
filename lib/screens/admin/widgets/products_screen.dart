import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kylikeio/models/product.dart';
import 'package:kylikeio/repository/products_repository.dart';
import 'package:kylikeio/screens/admin/widgets/product_dialog.dart';
import 'package:kylikeio/widgets/pdf_widget.dart';

class ProductsScreenController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxString categoryFilter = ProductCategories.all.obs;

  @override
  void onInit() async {
    products.addAll(await getProducts());
    categoryFilter.stream.listen((event) async {
      products.addAll(await getProducts());
      if (event != ProductCategories.all) products.retainWhere((p) => p.category == event);
    });

    super.onInit();
  }

  Future<List<Product>> getProducts() async {
    products.clear();
    List<Product> p = await ProductsRepository().getProducts();
    p.sort(
      (a, b) => a.name!.compareTo(b.name!),
    );
    return p;
  }

  Future addProduct(Product p) async {
    if (p.name != null && p.price != null) {
      String? id = await ProductsRepository().addProduct(p);
      p.id = id;
      products.insert(0, p);
    }
  }

  Future editProduct(Product p) async {
    if (p.name != null && p.price != null) {
      int index = products.indexWhere((product) => product.id == p.id);
      products.removeAt(index);
      products.insert(index, p);
      if (p.id != null) await ProductsRepository().editProduct(p);
    }
  }

  Future deleteProduct(String? id) async {
    products.removeWhere((product) => product.id == id);
    products.refresh();
    if (id != null) await ProductsRepository().deleteProduct(id);
  }

  List<Product> generateDummyProducts() {
    List<Product> products = [];

    for (int i = 0; i < 20; i++) {
      Product product = Product();
      product.id = 'product_$i';
      product.name = 'Product $i';
      switch (i % 4) {
        case 0:
          product.category = ProductCategories.coffee;
          break;
        case 1:
          product.category = ProductCategories.sandwich;
          break;
        case 2:
          product.category = ProductCategories.drinks;
        case 3:
          product.category = ProductCategories.snacks;
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
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          margin: EdgeInsets.all(32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => DropdownButton(
                  hint: Text("Κατηγορία"),
                  isExpanded: false,
                  underline: Container(),
                  value: _controller.categoryFilter.value,
                  onChanged: (String? v) {
                    _controller.categoryFilter.value = v!;
                  },
                  items: [
                    ProductCategories.all,
                    ProductCategories.coffee,
                    ProductCategories.sandwich,
                    ProductCategories.drinks,
                    ProductCategories.snacks,
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
              Wrap(
                children: [
                  MaterialButton(
                    hoverElevation: 0,
                    elevation: 0,
                    padding: EdgeInsets.all(16),
                    color: Get.theme.primaryColor.withOpacity(0.7),
                    child: Text(
                      "Εξαγωγή Τιμοκαταλόγου",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      await PDF.exportPdf(
                        documentTitle: "ΤΙΜΟΚΑΤΑΛΟΓΟΣ",
                        products: _controller.products,
                      );
                    },
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  MaterialButton(
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
                          p.category = ProductCategories.coffee;
                          return ProductDialog(product: p);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
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
        columnSpacing: 0,
        columns: [
          DataColumn(
            label: Flexible(
              child: Text(
                'Σύνολο: ${products.length}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          DataColumn(
            label: Flexible(
              child: Text('Όνομα'),
            ),
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
            label: Flexible(
              child: Text('Κατηγορία'),
            ),
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
            label: Flexible(
              child: Text('Τιμή'),
            ),
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
            label: Flexible(
              child: Text('Απόθεμα'),
            ),
            onSort: (columnIndex, ascending) {
              _sortColumnIndex.value = columnIndex;
              _sortAscending.value = ascending;
              _controller.products.sort((a, b) {
                if (a.availableAmount == null && b.availableAmount == null) {
                  return 0; // Both values are null, consider them equal
                } else if (a.availableAmount == null) {
                  return ascending
                      ? 1
                      : -1; // Null values come last when sorting in ascending order, first when sorting in descending order
                } else if (b.availableAmount == null) {
                  return ascending
                      ? -1
                      : 1; // Null values come first when sorting in ascending order, last when sorting in descending order
                } else {
                  // Both values are not null, perform normal comparison
                  return ascending
                      ? a.availableAmount!.compareTo(b.availableAmount!)
                      : b.availableAmount!.compareTo(a.availableAmount!);
                }
              });
            },
          ),
          DataColumn(
            label: Flexible(
              child: Text('Σημειώσεις'),
            ),
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
                Tooltip(
                  message: product.active ? "Διαθέσιμο" : "Μη διαθέσιμο",
                  child: CupertinoCheckbox(
                    value: product.active,
                    onChanged: null,
                  ),
                ),
              ),
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
                Text(product.availableAmount?.toString() ?? ''),
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
                    if (product.id != null) await _controller.deleteProduct(product.id);
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
