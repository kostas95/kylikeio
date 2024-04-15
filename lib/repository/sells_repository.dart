import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kylikeio/models/product_sold.dart';

class SellsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSell(ProductSold productSold) async {
    try {
      // Reference to the document for the user in Firestore
      CollectionReference productsSold = _firestore.collection('products_sold');

      // Write data to Firestore
      await productsSold.add(productSold.toMap());
    } catch (e) {
      print('Failed to write data to Firestore: $e');
      // Handle error
    }
  }

  Future<void> deleteSell(String id) async {
    try {
      // Reference to the document for the user in Firestore
      DocumentReference productSold = _firestore.collection('products_sold').doc(id);

      // Write data to Firestore
      await productSold.delete();
    } catch (e) {
      print('Failed to write data to Firestore: $e');
      // Handle error
    }
  }

  Future<List<ProductSold>> getSells(DateTime dateTime) async {
    List<ProductSold> dataList = <ProductSold>[];
    final CollectionReference _collection = FirebaseFirestore.instance.collection('products_sold');
    try {
      // Define the start and end of the day
      DateTime startOfDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
      DateTime endOfDay = DateTime(dateTime.year, dateTime.month, dateTime.day + 1);

      QuerySnapshot querySnapshot = await _collection
          .where(
            'date',
            isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
            isLessThan: endOfDay.toIso8601String(),
          )
          .get();
      querySnapshot.docs.forEach((DocumentSnapshot document) {
        dataList.add(
          ProductSold.fromMap(
            document.id,
            document.data(),
          ),
        );
      });
      return dataList;
    } catch (e) {
      // Handle errors
      print("Failed to retrieve data: $e");
      return [];
    }
  }

  Future<void> deleteLastDocument() async {
    try {
      final CollectionReference _collection = FirebaseFirestore.instance.collection('products_sold');
      final CollectionReference _productsCollection = FirebaseFirestore.instance.collection('products');

      // Query to get the last document based on a timestamp field
      QuerySnapshot querySnapshot = await _collection.orderBy('date', descending: true).limit(1).get();

      // Check if there's any document
      if (querySnapshot.docs.isNotEmpty) {
        // Get the reference to the last document
        DocumentSnapshot lastDocument = querySnapshot.docs.first;

        // Get the sold amount from the last document
        int soldAmount = lastDocument.get("quantity");
        String productId = lastDocument.get("productId");

        // Delete the last sold document
        await lastDocument.reference.delete();

        // Update the available product amount in the database by adding the sold amount
        QuerySnapshot productSnapshot = await _productsCollection.get();
        if (productSnapshot.docs.isNotEmpty) {
          DocumentSnapshot productDocument = await _productsCollection.doc(productId).get();
          int currentAvailableAmount = productDocument.get("amountAvailable") ?? 0;
          int updatedAvailableAmount = currentAvailableAmount + soldAmount;
          await productDocument.reference.update({"amountAvailable": updatedAvailableAmount});
          print("Product available amount updated successfully.");
        } else {
          print("No product documents found.");
        }
      } else {
        print("No sold documents found.");
      }
    } catch (e) {
      // Handle errors
      print("Failed to delete last document and update available amount: $e");
    }
  }
}
