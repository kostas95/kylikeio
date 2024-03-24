import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kylikeio/models/product.dart';

class ProductsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Other methods...

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
}
