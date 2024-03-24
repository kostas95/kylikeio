import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kylikeio/models/product.dart';
import 'package:kylikeio/repository/products_repository.dart';

class MainScreenController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxInt quantity = 0.obs;

  @override
  void onInit() async {
    products.addAll(await getProducts());
    // products.addAll(generateDummyProducts());

    super.onInit();
  }

  Future<List<Product>> getProducts() async {
    return await ProductsRepository().getProducts();
  }

  resetQuantity() {
    quantity.value = 0;
  }

  increaseQuantity() {
    quantity.value ++;
  }

  decreaseQuantity() {
    quantity.value --;
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

class MainScreen extends StatelessWidget {
  final MainScreenController _controller = Get.put<MainScreenController>(MainScreenController());

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor.withOpacity(0.2),
      floatingActionButton: QuantityButton(),
      appBar: AppBar(
        title: const Text('ΚΥΛΙΚΕΙΟ ΔΥΒ'),
        leading: const Image(
          image: AssetImage(
            'assets/dyv_logo.png',
          ),
        ),
        centerTitle: true,
        actions: [
          const Image(
            image: AssetImage(
              'assets/depli.gif',
            ),
          )
        ],
      ),
      body: Row(
        children: List.generate(
          4,
          (index) => Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Get.theme.primaryColor,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    tileColor: Colors.white,
                    title: Center(
                      child: Text(
                        getCategoryTitle(index),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => GridView(
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 256,
                          childAspectRatio: 1,
                          mainAxisExtent: 128,
                        ),
                        children: List.from(
                          _controller.products
                              .where(
                                (p) => p.category == getCategoryTitle(index),
                              )
                              .map(
                                (p) => GridTile(
                                  child: MaterialButton(
                                    hoverElevation: 0,
                                    animationDuration: Duration.zero,
                                    onPressed: () {},
                                    color: Get.theme.primaryColor.withOpacity(0.6),
                                    child: Center(
                                      child: Text(
                                        p.name ?? "Άγνωστο προϊόν",
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getCategoryTitle(int index) {
    switch (index) {
      case 0:
        return "Καφέδες - Ροφήματα";
      case 1:
        return "Σφολιάτες - Σάντουιτς";
      case 2:
        return "Αναψυκτικά";
      case 3:
        return "Chips - Snacks";
      default:
        return "Άλλο";
    }
  }
}

class QuantityButton extends StatelessWidget {
  final MainScreenController _controller = Get.find<MainScreenController>();

  QuantityButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Get.theme.primaryColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      width: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: Center(
              child: Text("ΠΟΣΟΤΗΤΑ ΠΡΟΪΟΝΤΟΣ"),
            ),
          ),
          ListTile(
            leading: Container(
              width: 50.0,
              height: 50.0,
              child: IconButton(
                onPressed: () {
                  _controller.increaseQuantity();
                },
                color: Get.theme.primaryColor,
                icon: Icon(Icons.add),
                iconSize: 24.0,
              ),
            ),
            trailing: Container(
              width: 50.0,
              height: 50.0,
              child: IconButton(
                onPressed: () {
                  _controller.decreaseQuantity();
                },
                color: Get.theme.primaryColor,
                icon: Icon(Icons.remove),
                iconSize: 24.0,
              ),
            ),
            title: Obx(
              () => Center(
                child: Text(
                  _controller.quantity.value.toString(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
