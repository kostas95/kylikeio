import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    title: Center(
                      child: Text(
                        getCategoryTitle(index),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 256,
                        childAspectRatio: 1,
                        mainAxisExtent: 128,
                      ),
                      children: List.generate(
                        10, // Number of grid items
                        (index) {
                          return GridTile(
                            child: MaterialButton(
                              hoverElevation: 0,
                              animationDuration: Duration.zero,
                              onPressed: () {},
                              color: Get.theme.primaryColor.withOpacity(0.6),
                              child: Center(
                                child: Text(
                                  'Item $index',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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
  const QuantityButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Get.theme.primaryColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      width: 250,
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          child: IconButton(
            onPressed: () {
              // Button pressed callback
              print('Icon Button pressed');
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
              // Button pressed callback
              print('Icon Button pressed');
            },
            color: Get.theme.primaryColor,
            icon: Icon(Icons.remove),
            iconSize: 24.0,
          ),
        ),
        title: Text('quantity'),
      ),
    );
  }
}
