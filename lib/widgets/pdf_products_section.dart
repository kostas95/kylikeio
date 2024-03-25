import 'package:get/get.dart';
import 'package:kylikeio/models/product.dart';
import 'package:pdf/widgets.dart';

class ProductsSection extends StatelessWidget {
  final List<Product> products;
  final String title;

  ProductsSection({
    required this.products,
    required this.title,
  });

  @override
  Widget build(Context context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Get.theme.textTheme.bodyLarge?.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        GridView(
          crossAxisCount: 2,
          direction: Axis.vertical,
          crossAxisSpacing: 16,
          mainAxisSpacing: 0,
          childAspectRatio: 1 / 10,
          padding: EdgeInsets.zero,
          children: List.from(
            products.map(
              (p) => Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    p.name.toString(),
                    style: TextStyle(
                      fontSize: Get.textTheme.bodyMedium?.fontSize,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    p.price?.toStringAsFixed(2) ?? "-",
                    style: TextStyle(
                      fontSize: Get.textTheme.bodyMedium?.fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
