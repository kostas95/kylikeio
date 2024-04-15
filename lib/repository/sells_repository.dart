import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kylikeio/models/product_sold.dart';

class SellsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addSell(ProductSold productSold) async {
    try {
      // Reference to the document for the user in Firestore
      CollectionReference productsSold = _firestore.collection('products_sold');

      // Write data to Firestore
      DocumentReference docRef = await productsSold.add(productSold.toMap());

      // Return the ID of the newly added document
      return docRef.id;
    } catch (e) {
      print('Failed to write data to Firestore: $e');
      return null;
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

  /// Might need this in future
  Future<List<ProductSold>> getLastThreeTransactions() async {
    try {
      final CollectionReference _collection = FirebaseFirestore.instance.collection('products_sold');
      // Query to get the last three documents based on a timestamp field
      QuerySnapshot querySnapshot = await _collection.orderBy('date', descending: true).limit(3).get();

      // Check if there are any documents
      if (querySnapshot.docs.isNotEmpty) {
        // Return the list of the last three documents
        final List<ProductSold> data = querySnapshot.docs
            .map(
              (e) => ProductSold.fromMap(
                e.id,
                e.data(),
              ),
            )
            .toList();
        data.sort((a, b) => b.date!.compareTo(a.date!));
        return data;
      } else {
        // No documents found
        print("No sold documents found.");
        return [];
      }
    } catch (e) {
      // Handle errors
      print("Failed to retrieve last three transactions: $e");
      return [];
    }
  }

  /// Not used, might use it
  // Future<void> deleteDocumentById(String id) async {
  //   try {
  //     final CollectionReference _collection = FirebaseFirestore.instance.collection('products_sold');
  //     final CollectionReference _productsCollection = FirebaseFirestore.instance.collection('products');
  //     // Get the reference to the document using its ID
  //     DocumentReference documentRef = _collection.doc(id);
  //
  //     // Check if the document exists
  //     DocumentSnapshot documentSnapshot = await documentRef.get();
  //     if (documentSnapshot.exists) {
  //       // Get the sold amount from the document
  //       int soldAmount = documentSnapshot.get("quantity");
  //       String productId = documentSnapshot.get("productId");
  //
  //       // Delete the document
  //       await documentRef.delete();
  //
  //       // Update the available product amount in the database by adding the sold amount
  //       DocumentSnapshot productDocument = await _productsCollection.doc(productId).get();
  //       int currentAvailableAmount = productDocument.get("amountAvailable") ?? 0;
  //       int updatedAvailableAmount = currentAvailableAmount + soldAmount;
  //       await _productsCollection.doc(productId).update({"amountAvailable": updatedAvailableAmount});
  //       print("Product available amount updated successfully.");
  //     } else {
  //       // Document doesn't exist
  //       print("Document with ID $id does not exist in collection products_sold.");
  //     }
  //   } catch (e) {
  //     // Handle errors
  //     print("Failed to delete document with ID $id: $e");
  //   }
  // }

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
