import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kylikeio/models/sales.dart';

class SalesScreenController {
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  Sales? sales;
}

class SalesScreen extends StatelessWidget {
  final SalesScreenController _controller = Get.put<SalesScreenController>(SalesScreenController());

  SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.all(
            32,
          ),
          child: MaterialButton(
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
        ),
        Expanded(
          child: Card(
            child: ListView(
              children: [
                if (_controller.sales != null && _controller.sales?.date != null)
                  ListTile(
                    title: Text("Ημερομηνία"),
                    subtitle: Text(DateFormat.yMMMd().format(_controller.sales!.date!)),
                  ),
                if (_controller.sales != null && _controller.sales?.earnings != null)
                ListTile(
                  title: Text("Έσοδα"),
                  subtitle: Text(_controller.sales?.earnings.toString() ?? "???"),
                ),
                if (_controller.sales != null && _controller.sales!.productSold != null)
                  ExpansionTile(
                    title: Text("Προϊόντα που πουλήθηκαν"),
                    children: _controller.sales!.productSold!
                        .map(
                          (e) => ListTile(
                            title: Text(e.name!),
                            subtitle: Text(
                              e.quantity.toString(),
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
