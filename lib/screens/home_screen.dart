import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kylikeio/models/product.dart';
import 'package:kylikeio/models/product_sold.dart';
import 'package:kylikeio/repository/products_repository.dart';
import 'package:kylikeio/repository/sells_repository.dart';

class MainScreenController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxInt quantity = 1.obs;
  final RxBool cancelButtonIsVisible = false.obs;
  ProductSold? lastProductSold;
  final RxList<ProductSold> lastProductsSoldRx = <ProductSold>[].obs;

  @override
  void onInit() async {
    products.addAll((await getProducts()).where((prod) => prod.active));
    lastProductsSoldRx.addAll(await SellsRepository().getLastThreeTransactions());

    super.onInit();
  }

  Future<List<Product>> getProducts() async {
    return await ProductsRepository().getProducts();
  }

  void increaseQuantity() {
    if (quantity.value < 20) quantity.value++;
  }

  void decreaseQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  Future makeTransaction({required Product product}) async {
    ProductSold ps = ProductSold();
    ps.date = DateTime.now();
    ps.name = product.name;
    ps.price = product.price;
    ps.quantity = quantity.value;
    ps.category = product.category;
    ps.productId = product.id;

    // Cache the last item that was sold
    lastProductSold = ps;

    //Handle the UI
    _resetQuantity();
    _displayCancelButton();

    lastProductSold?.id = await SellsRepository().addSell(ps);

    // if (lastProductSold != null) {
    //   // We need 3 items in this list
    //   // If 3 or more, remove the first
    //   if (lastProductsSoldRx.length >= 3) {
    //     lastProductsSoldRx.removeAt(0);
    //   }
    //   // Add the newly sold product
    //   lastProductsSoldRx.add(lastProductSold!);
    // }

    // Update the warehouse
    await ProductsRepository().updateProductAmount(
      productId: ps.productId!,
      amountDifference: ps.quantity!,
    );

    // Get the last 3 transactions
    lastProductsSoldRx.clear();
    lastProductsSoldRx.addAll(await SellsRepository().getLastThreeTransactions());
  }

  Future cancelLastTransaction() async {
    cancelButtonIsVisible.value = false;

    await SellsRepository().deleteLastDocument();

    // Get the last 3 transactions
    lastProductsSoldRx.clear();
    lastProductsSoldRx.addAll(await SellsRepository().getLastThreeTransactions());
  }

  void _resetQuantity() {
    quantity.value = 1;
  }

  Future _displayCancelButton() async {
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
      persistentFooterAlignment: AlignmentDirectional.center,
      bottomNavigationBar: QuantityButton(),
      drawer: Drawer(
        width: 350,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'ΤΕΛΕΥΤΑΙΕΣ ΠΩΛΗΣΕΙΣ',
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(),
              Obx(
                () => _controller.lastProductsSoldRx.isNotEmpty
                    ? Column(
                        children: _controller.lastProductsSoldRx
                            .map<Widget>(
                              (p) => ListTile(
                                title: Text(
                                  (p.name ?? "-"),
                                ),
                                subtitle: p.date != null
                                    ? Text(
                                        DateFormat.d().format(p.date!) +
                                            "/" +
                                            DateFormat.M().format(p.date!) +
                                            ", " +
                                            DateFormat.Hms().format(p.date!),
                                      )
                                    : null,
                                trailing: Text(
                                  "Ποσότητα: ${p.quantity.toString()}",
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : ListTile(
                        title: Text(
                          "Δεν έχουν γίνει πωλήσεις σήμερα",
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('ΚΥΛΙΚΕΙΟ ΔΥΒ'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: const Image(
              image: AssetImage(
                'assets/dyv_logo.png',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: const Image(
              image: AssetImage(
                'assets/depli.gif',
              ),
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
      color: Colors.white,
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "ΠΟΣΟΤΗΤΑ ΠΡΟΪΟΝΤΟΣ",
              style: TextStyle(
                fontSize: Get.textTheme.bodyLarge?.fontSize,
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
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
              Obx(
                () => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _controller.quantity.value.toString(),
                    style: TextStyle(
                      fontSize: Get.textTheme.bodyLarge?.fontSize,
                    ),
                  ),
                ),
              ),
              Container(
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
              )
            ],
          )
        ],
      ),
    );
  }
}
