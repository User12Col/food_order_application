import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_order_app/model/food.dart';
import 'package:uuid/uuid.dart';

class FoodRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart(Food food) async {
    try {
      var foodSnap = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('carts')
          .doc(food.id)
          .get();
      if (foodSnap.exists) {
        await _firestore
            .collection('users')
            .doc(_firebaseAuth.currentUser!.uid)
            .collection('carts')
            .doc(food.id)
            .update({
          'quantity': foodSnap.data()!['quantity'] + 1,
          'totalPrice': (int.parse(foodSnap.data()!['totalPrice']) + int.parse(foodSnap.data()!['price'])).toString(),
        });
      } else {
        await _firestore
            .collection('users')
            .doc(_firebaseAuth.currentUser!.uid)
            .collection('carts')
            .doc(food.id)
            .set({
          'id': food.id,
          'name': food.name,
          'describe': food.describe,
          'price': food.price,
          'salePrice': food.salePrice,
          'image': food.image,
          'quantity': 1,
          'totalPrice':food.price
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> decreaseQuantity(String id) async {
    try {
      var foodSnap = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('carts')
          .doc(id)
          .get();
      if (foodSnap.exists && foodSnap.data()!['quantity'] > 1) {
        await _firestore
            .collection('users')
            .doc(_firebaseAuth.currentUser!.uid)
            .collection('carts')
            .doc(id)
            .update({
          'quantity': foodSnap.data()!['quantity'] - 1,
          'totalPrice': (int.parse(foodSnap.data()!['totalPrice']) - int.parse(foodSnap.data()!['price'])).toString(),
        });
      } else if (foodSnap.data()!['quantity'] == 1) {
        await removeFromCart(id);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeFromCart(String foodID) async {
    try {
      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('carts')
          .doc(foodID)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
