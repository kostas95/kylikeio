import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kylikeio/models/product.dart';
import 'package:kylikeio/screens/admin/widgets/products_screen.dart';

class ProductDialog extends StatelessWidget {
  final RxString cat = "Καφέδες - Ροφήματα".obs;
  final Product product;
  final ProductsScreenController _controller = Get.find<ProductsScreenController>();
  final bool editMode;

  ProductDialog({
    super.key,
    required this.product,
    this.editMode = false,
  }) {
    if (product.category != null) {
      cat.value = product.category!;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    controller: TextEditingController(
                      text: product.name,
                    ),
                    onChanged: (v) {
                      product.name = v;
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
                      product.category = v;
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
                    controller: TextEditingController(
                      text: product.price != null ? product.price.toString() : "",
                    ),
                    onChanged: (v) {
                      product.price = double.tryParse(v);
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[0-9.]"),
                      ),
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
                    controller: TextEditingController(
                      text: product.notes,
                    ),
                    onChanged: (v) {
                      product.notes = v;
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
            Get.back();
            if (editMode) {
              await _controller.editProduct(product);
            } else {
              await _controller.addProduct(product);
            }
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
            Get.back();
          },
          child: Text('Κλείσιμο'),
        ),
      ],
    );
  }
}
