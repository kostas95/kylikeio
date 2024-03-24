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
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(editMode ? 'Επεξεργασία Προϊόντος' : 'Προσθήκη Προϊόντος'),
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.grey,
            ),
            padding: EdgeInsets.all(16),
            color: Colors.transparent,
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
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
                      text: product.availableAmount != null ? product.availableAmount.toString() : "",
                    ),
                    onChanged: (v) {
                      product.availableAmount = int.tryParse(v);
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[0-9]"),
                      ),
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) {
                          final text = newValue.text;
                          return text.isEmpty
                              ? newValue
                              : int.tryParse(text) == null
                                  ? oldValue
                                  : newValue;
                        },
                      ),
                    ],
                  ),
                  subtitle: Text("Απόθεμα"),
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
              SizedBox(
                width: 512,
                child: Obx(
                  () {
                    RxBool activeRx = product.active.obs;
                    return CheckboxListTile(
                      onChanged: (v) {
                        if (v != null) {
                          product.active = v;
                          activeRx.value = product.active;
                        }
                      },
                      value: activeRx.value,
                      title: Text("Διαθέσιμο προϊόν"),
                      subtitle: Text("Αν απενεργοποιηθεί δε θα εμφανίζεται στον τιμοκατάλογο"),
                    );
                  },
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
            if (product.price != null && product.name != null) {
              Get.back();
              if (editMode) {
                await _controller.editProduct(product);
              } else {
                await _controller.addProduct(product);
              }
            }
          },
          child: Text(
            'Προσθήκη',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        if (product.id != null && editMode)
          MaterialButton(
            hoverElevation: 0,
            elevation: 0,
            padding: EdgeInsets.all(16),
            color: Colors.red,
            onPressed: () async {
              Get.back();
              await _controller.deleteProduct(product.id!);
            },
            child: Text(
              'Διαγραφή',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
