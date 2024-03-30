import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kylikeio/models/product.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'pdf_products_section.dart';

class PDF {
  static Future exportPdf({
    required String documentTitle,
    required List<Product> products,
  }) async {
    //Init pdf
    final pdf = Document();

    //Image logo
    const assetImageLocation = 'assets/dyv_logo.png';
    ByteData byteData = await rootBundle.load(assetImageLocation);
    final uint8List = byteData.buffer.asUint8List();
    final logo = MemoryImage(uint8List);

    Widget buildHeader(Context context, {String? userName}) {
      return Header(
        child: Center(
          child: Text(
            documentTitle,
            style: TextStyle(
              fontSize: Get.textTheme.headlineSmall?.fontSize,
            ),
          ),
        ),
      );
    }

    Widget buildFooter(Context context) {
      return Footer(
        leading: Text("Κυλικείο ΔΥΒ"),
        trailing: Text(
          DateTime.now().year.toString(),
        ),
      );
    }

    pdf.addPage(
      MultiPage(
        header: buildHeader,
        footer: buildFooter,
        pageTheme: PageTheme(
          theme: ThemeData.withFont(
            base: Font.ttf(await rootBundle.load("assets/pdf-assets/fonts/open-sans/OpenSans-Regular.ttf")),
            bold: Font.ttf(await rootBundle.load("assets/pdf-assets/fonts/open-sans/OpenSans-Bold.ttf")),
            italic: Font.ttf(await rootBundle.load("assets/pdf-assets/fonts/open-sans/OpenSans-Italic.ttf")),
            icons: Font.ttf(await rootBundle.load('assets/pdf-assets/material.ttf')),
          ),
          buildBackground: (Context c) => Opacity(
            opacity: 0.2,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: logo,
                    fit: BoxFit.contain
                ),
              ),
              child: Container(),
            ),
          ),
        ),
        maxPages: 10,
        build: (Context context) => <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.center,
            child: ProductsSection(
              products: products.where((e) => e.category == ProductCategories.coffee && e.active).toList(),
              title: ProductCategories.coffee,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.center,
            child: ProductsSection(
              products: products.where((e) => e.category == ProductCategories.sandwich && e.active).toList(),
              title: ProductCategories.sandwich,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.center,
            child: ProductsSection(
              products: products.where((e) => e.category == ProductCategories.drinks && e.active).toList(),
              title: ProductCategories.drinks,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.center,
            child: ProductsSection(
              products: products.where((e) => e.category == ProductCategories.snacks && e.active).toList(),
              title: ProductCategories.snacks,
            ),
          ),
        ],
      ),
    );

    if (GetPlatform.isWeb || GetPlatform.isAndroid) {
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
        return pdf.save();
      });
    }
  }
}
