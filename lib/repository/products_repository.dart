import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kylikeio/models/product.dart';

class ProductsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct(Product product) async {
    try {
      // Reference to the document for the user in Firestore
      CollectionReference products = _firestore.collection('products');

      // Write data to Firestore
      await products.add(product.toMap());
    } catch (e) {
      print('Failed to write data to Firestore: $e');
      // Handle error
    }
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
