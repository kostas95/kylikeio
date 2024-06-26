import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kylikeio/models/product.dart';
import 'package:kylikeio/models/product_sold.dart';
import 'package:kylikeio/repository/sells_repository.dart';

class SalesScreenController extends GetxController {
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxList<ProductSold> productsSold = <ProductSold>[].obs;
  final RxString categoryFilter = ProductCategories.all.obs;

  @override
  void onInit() async {
    await getSells();
    selectedDate.stream.listen((event) async {
      await getSells();
      if (categoryFilter.value != ProductCategories.all)
        productsSold.retainWhere((p) => p.category == categoryFilter.value);
    });
    categoryFilter.stream.listen((event) async {
      await getSells();
      if (event != ProductCategories.all) productsSold.retainWhere((p) => p.category == event);
    });
    super.onInit();
  }

  Future getSells() async {
    productsSold.clear();
    productsSold.assignAll(
      await SellsRepository().getSells(
        selectedDate.value,
      ),
    );
    productsSold.sort(
      (a, b) => a.date!.compareTo(b.date!),
    );
  }

  int calculateDailyTotalQuantity() {
    int total = 0;
    productsSold.forEach((element) {
      if (element.quantity != null) total += element.quantity!;
    });

    return total;
  }

  double calculateDailyTotalIncome() {
    double total = 0;
    productsSold.forEach((element) {
      if (element.getIncome != null) total += element.getIncome!;
    });

    return total;
  }

  void exportToExcel({
    required BuildContext context,
    required List<ProductSold> products,
    required int totalQuantity,
    required double totalIncome,
    required DateTime selectedDate,
  }) {
    // Create a new Excel workbook
    var excel = Excel.createExcel();

    // Add a sheet to the workbook
    var sheet = excel['Sheet1'];

    if (sheet.rows.isNotEmpty)
      sheet.rows.first.forEach(
        (e) {
          if (e != null)
            sheet.setColumnWidth(
              e.columnIndex,
              1000,
            );
        },
      );

    CellStyle cellStyle = CellStyle(
      bold: true,
      fontFamily: getFontFamily(FontFamily.Arial),
      rotation: 0,
    );

    // Add columns to the sheet
    sheet.appendRow(
      [
        TextCellValue("Όνομα"),
        TextCellValue('Κατηγορία'),
        TextCellValue('Τιμή'),
        TextCellValue('Ποσότητα'),
        TextCellValue('Έσοδα'),
        TextCellValue('Ημερομηνία'),
      ],
    );

    // Add the total row at the beginning
    sheet.insertRowIterables(
      [
        TextCellValue('ΣΥΝΟΛΟ'),
        TextCellValue(''),
        TextCellValue(''),
        IntCellValue(totalQuantity),
        DoubleCellValue(totalIncome.toPrecision(2)),
        TextCellValue(
          DateFormat('d/M/yyyy').format(selectedDate),
        ),
      ],
      1,
    );

    // Bold for first 2 rows
    if (sheet.rows.isNotEmpty) {
      sheet.row(0).forEach((e) => e?.cellStyle = cellStyle);
      sheet.row(1).forEach((e) => e?.cellStyle = cellStyle);
    }

    // Add data rows to the sheet
    products.forEach(
      (product) {
        sheet.appendRow(
          [
            TextCellValue(product.name ?? ''),
            TextCellValue(product.category ?? ''),
            DoubleCellValue(product.price ?? 0),
            IntCellValue(product.quantity ?? 0),
            DoubleCellValue(product.getIncome?.toPrecision(2) ?? 0),
            TextCellValue(
              DateFormat.Hm().format(product.date ?? DateTime.now()),
            )
            // DateTimeCellValue.fromDateTime(
            //   product.date ?? DateTime.now(),
            // ),
          ],
        );
      },
    );

    // Save the workbook
    excel.save(fileName: '${DateFormat('d/M/yyyy').format(selectedDate)}.xlsx');
  }
}

class SalesScreen extends StatelessWidget {
  final SalesScreenController _controller = Get.put<SalesScreenController>(SalesScreenController());

  SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(
              32,
            ),
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
                Row(
                  children: [
                    MaterialButton(
                      hoverElevation: 0,
                      elevation: 0,
                      padding: EdgeInsets.all(16),
                      color: Get.theme.primaryColor.withOpacity(0.7),
                      child: Text(
                        'Εξαγωγή Πωλήσεων',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        _controller.exportToExcel(
                          context: context,
                          products: _controller.productsSold,
                          selectedDate: _controller.selectedDate.value,
                          totalIncome: _controller.calculateDailyTotalIncome(),
                          totalQuantity: _controller.calculateDailyTotalQuantity(),
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
                        DateFormat.yMMMd().format(_controller.selectedDate.value),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        DateTime? d = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2019, 1, 1),
                          lastDate: DateTime.now(),
                        );
      
                        if (d != null) {
                          _controller.selectedDate.value = d;
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Card(
              child: ListView(
                children: [
                  ProductTable(
                    products: _controller.productsSold,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductTable extends StatelessWidget {
  final List<ProductSold> products;
  final SalesScreenController _controller = Get.find<SalesScreenController>();
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
              child: Text('Όνομα'),
            ),
            onSort: (columnIndex, ascending) {
              _sortColumnIndex.value = columnIndex;
              _sortAscending.value = ascending;
              _controller.productsSold.sort(
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
              _controller.productsSold.sort(
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
              _controller.productsSold.sort(
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
              child: Text('Ποσότητα'),
            ),
            onSort: (columnIndex, ascending) {
              _sortColumnIndex.value = columnIndex;
              _sortAscending.value = ascending;
              _controller.productsSold.sort(
                (a, b) {
                  if (ascending) {
                    return a.quantity!.compareTo(b.quantity!);
                  } else {
                    return b.quantity!.compareTo(a.quantity!);
                  }
                },
              );
            },
          ),
          DataColumn(
            label: Flexible(
              child: Text('Έσοδα'),
            ),
            onSort: (columnIndex, ascending) {
              _sortColumnIndex.value = columnIndex;
              _sortAscending.value = ascending;
              _controller.productsSold.sort(
                (a, b) {
                  if (ascending) {
                    return a.getIncome!.compareTo(b.getIncome!);
                  } else {
                    return b.getIncome!.compareTo(a.getIncome!);
                  }
                },
              );
            },
          ),
          DataColumn(
            label: Flexible(
              child: Text('Ημερομηνία'),
            ),
            onSort: (columnIndex, ascending) {
              _sortColumnIndex.value = columnIndex;
              _sortAscending.value = ascending;
              _controller.productsSold.sort(
                (a, b) {
                  if (ascending) {
                    return a.date!.compareTo(b.date!);
                  } else {
                    return b.date!.compareTo(a.date!);
                  }
                },
              );
            },
          ),
        ],
        rows: products.map((product) {
          return DataRow(
            cells: [
              DataCell(
                SelectableText(
                  product.name ?? '',
                ),
              ),
              DataCell(
                Text(
                  product.category ?? '',
                ),
              ),
              DataCell(
                Text(
                  product.price?.toString() ?? '',
                ),
              ),
              DataCell(
                Text(
                  product.quantity != null ? product.quantity.toString() : "",
                ),
              ),
              DataCell(
                Text(
                  product.getIncome?.toStringAsFixed(2) ?? "-",
                ),
              ),
              DataCell(
                Text(
                  product.date != null ? DateFormat('d/M/yyyy, HH:mm').format(product.date!) : "",
                ),
              ),
            ],
          );
        }).toList()
          ..insert(
            0,
            DataRow(
              cells: [
                DataCell(
                  Text(
                    'ΣΥΝΟΛΟ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataCell(
                  Container(),
                ),
                DataCell(
                  Container(),
                ),
                DataCell(
                  Text(
                    _controller.calculateDailyTotalQuantity().toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    _controller.calculateDailyTotalIncome().toStringAsFixed(2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    DateFormat('d/M/yyyy').format(_controller.selectedDate.value),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
