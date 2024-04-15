import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kylikeio/models/product.dart';

class ProductsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addProduct(Product product) async {
    try {
      // Reference to the document for the user in Firestore
      CollectionReference products = _firestore.collection('products');

      // Write data to Firestore
      DocumentReference<Object?> ref = await products.add(product.toMap());
      return ref.id;
    } catch (e) {
      print('Failed to write data to Firestore: $e');
      // Handle error
    }
    return null;
  }

  Future<void> editProduct(Product p) async {
    try {
      // Reference to the document for the user in Firestore
      DocumentReference product = _firestore.collection('products').doc(p.id);

      // Write data to Firestore
      await product.update(p.toMap());
    } catch (e) {
      print('Failed to write data to Firestore: $e');
      // Handle error
    }
  }

  Future<void> updateProductAmount({required String productId, required int amountDifference}) async {
    try {
      DocumentReference docRef = _firestore.collection('products').doc(productId);
      DocumentSnapshot snapshot = await docRef.get();

      if (snapshot.exists) {
        int currentAmount = snapshot.get("amountAvailable");
        int newAmount = currentAmount - amountDifference;
        await docRef.update({"amountAvailable": newAmount});
      } else {
        print("Product with ID $productId does not exist.");
      }
    } catch (e) {
      print("Error updating product amount: $e");
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      // Reference to the document for the user in Firestore
      DocumentReference product = _firestore.collection('products').doc(productId);

      // Write data to Firestore
      await product.delete();
    } catch (e) {
      print('Failed to delete data from Firestore: $e');
      // Handle error
    }
  }

  Future<List<Product>> getProducts() async {
    List<Product> dataList = <Product>[];
    final CollectionReference _collection = FirebaseFirestore.instance.collection('products');
    try {
      QuerySnapshot querySnapshot = await _collection.get();
      querySnapshot.docs.forEach((DocumentSnapshot document) {
        dataList.add(
          Product.fromMap(
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
}
