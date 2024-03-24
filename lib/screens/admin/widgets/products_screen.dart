import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kylikeio/models/product.dart';
import 'package:kylikeio/repository/products_repository.dart';

class ProductsScreenController extends GetxController {
  final List<Product> products = [];

  @override
  void onInit() {
    super.onInit();
  }

  Future addProduct() async {
    Product p = Product();
    p.name = "Καφές";
    p.price = 1;
    if (p.name != null && p.price != null) {
      await ProductsRepository().addProduct(p);
    }
  }
}

class ProductsScreen extends StatelessWidget {
  final ProductsScreenController _controller = Get.put<ProductsScreenController>(ProductsScreenController());

  ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Center(
                      child: Text("Προσθήκη Προϊόντος"),
                    ),
                  ),
                  ListTile(
                    title: TextFormField(),
                    subtitle: Text("Όνομα Προϊόντος"),
                  ),
                  ListTile(
                    title: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final text = newValue.text;
                          return text.isEmpty
                              ? newValue
                              : double.tryParse(text) == null
                                  ? oldValue
                                  : newValue;
                        }),
                      ],
                    ),
                    subtitle: Text("Τιμή Προϊόντος"),
                  ),
                  ListTile(
                    title: TextFormField(),
                    subtitle: Text("Σημειώσεις"),
                  ),
                  MaterialButton(
                    hoverElevation: 0,
                    elevation: 0,
                    padding: EdgeInsets.all(16),
                    color: Get.theme.primaryColor.withOpacity(0.7),
                    onPressed: () async {
                      await _controller.addProduct();
                    },
                    child: Text(
                      'Προσθήκη',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: _controller.products
                .map(
                  (e) => ListTile(
                    title: Text(
                      e.name ?? "???",
                    ),
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}
