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

  Future<List<ProductSold>> getSells() async {
    List<ProductSold> dataList = <ProductSold>[];
    final CollectionReference _collection = FirebaseFirestore.instance.collection('products_sold');
    try {
      QuerySnapshot querySnapshot = await _collection.get();
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
    final CollectionReference _collection = FirebaseFirestore.instance.collection('products_sold');
    try {
      // Query to get the last document based on a timestamp field
      QuerySnapshot querySnapshot = await _collection.orderBy('date', descending: true).limit(1).get();

      // Check if there's any document
      if (querySnapshot.docs.isNotEmpty) {
        // Get the reference to the last document
        DocumentSnapshot lastDocument = querySnapshot.docs.first;

        // Delete the document
        await lastDocument.reference.delete();
      }
    } catch (e) {
      // Handle errors
      print("Failed to delete last document: $e");
    }
  }
}