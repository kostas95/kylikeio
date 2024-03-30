import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kylikeio/models/product.dart';
import 'package:kylikeio/models/product_sold.dart';
import 'package:kylikeio/repository/products_repository.dart';
import 'package:kylikeio/repository/sells_repository.dart';

class MainScreenController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxInt quantity = 1.obs;
  RxBool cancelButtonIsVisible = false.obs;
  ProductSold? lastProductSold;

  @override
  void onInit() async {
    products.addAll((await getProducts()).where((prod) => prod.active));

    super.onInit();
  }

  Future<List<Product>> getProducts() async {
    return await ProductsRepository().getProducts();
  }

  increaseQuantity() {
    if (quantity.value < 20) quantity.value++;
  }

  decreaseQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  makeTransaction({required Product product}) async {
    ProductSold ps = ProductSold();
    ps.date = DateTime.now();
    ps.name = product.name;
    ps.price = product.price;
    ps.quantity = quantity.value;
    ps.category = product.category;

    // Cache the last item that was sold
    lastProductSold = ps;

    //Handle the UI
    _resetQuantity();
    _displayCancelButton();

    await SellsRepository().addSell(ps);
  }

  cancelLastTransaction() async {
    cancelButtonIsVisible.value = false;

    await SellsRepository().deleteLastDocument();
  }

  _resetQuantity() {
    quantity.value = 1;
  }

  _displayCancelButton() async {
    cancelButtonIsVisible.value = true;
    Timer(
      Duration(seconds: 60),
      () {
        cancelButtonIsVisible.value = false;
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainScreenController _controller = Get.put<MainScreenController>(MainScreenController());
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
      body: Column(
        children: [
          Obx(() {
            if (_controller.cancelButtonIsVisible.value) {
              return ListTile(
                tileColor: Colors.red,
                onTap: () {
                  showFullScreenDialog(
                    context,
                    product: _controller.lastProductSold,
                    productQuantity: _controller.lastProductSold!.quantity!,
                    add: false,
                  );
                },
                title: Center(
                  child: Text(
                    "ΑΚΥΡΩΣΗ ΤΕΛΕΥΤΑΙΑΣ ΠΩΛΗΣΗΣ",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }
            return Container();
          }),
          Expanded(
            child: Row(
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
                                mainAxisExtent: 64,
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
                                          onPressed: () {
                                            if (p.name != null)
                                              showFullScreenDialog(
                                                context,
                                                product: p,
                                                productQuantity: _controller.quantity.value,
                                                add: true,
                                              );
                                          },
                                          color: Get.theme.primaryColor.withOpacity(0.6),
                                          child: Center(
                                            child: Wrap(
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Text(
                                                  p.name ?? "Άγνωστο προϊόν",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                if (p.price != null)
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                if (p.price != null)
                                                  Text(
                                                  "(" + p.price!.toStringAsFixed(2) + ")",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  )
                                              ],
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
          ),
        ],
      ),
    );
  }

  String getCategoryTitle(int index) {
    switch (index) {
      case 0:
        return ProductCategories.coffee;
      case 1:
        return ProductCategories.sandwich;
      case 2:
        return ProductCategories.drinks;
      case 3:
        return ProductCategories.snacks;
      default:
        return "Άλλο";
    }
  }

  void showFullScreenDialog(
    BuildContext context, {
    required dynamic product,
    required int productQuantity,
    bool add = true,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Use WillPopScope to prevent closing dialog by tapping outside
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: add ? Colors.green : Colors.red,
            content: Container(
              width: Get.width,
              height: Get.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (add)
                      Text(
                        'ΠΟΥΛΗΘΗΚΕ',
                        style: TextStyle(
                          fontSize: Get.textTheme.headlineLarge!.fontSize!,
                          color: Colors.white,
                        ),
                      )
                    else
                      Text(
                        'ΑΚΥΡΩΘΗΚΕ',
                        style: TextStyle(
                          fontSize: Get.textTheme.headlineLarge!.fontSize!,
                          color: Colors.white,
                        ),
                      ),
                    Text(
                      'ΕΙΔΟΣ: ${product.name}',
                      style: TextStyle(
                        fontSize: Get.textTheme.headlineLarge!.fontSize!,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'ΠΟΣΟΤΗΤΑ: ${productQuantity}',
                      style: TextStyle(
                        fontSize: Get.textTheme.headlineLarge!.fontSize!,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // Close the dialog after 500 milliseconds
    Timer(
      Duration(milliseconds: 500),
      () {
        Navigator.of(context).pop();
      },
    );

    if (add) {
      await Get.find<MainScreenController>().makeTransaction(product: product as Product);
    } else
      await Get.find<MainScreenController>().cancelLastTransaction();
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
