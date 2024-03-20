import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_order_app/model/order.dart' as model;
import 'package:uuid/uuid.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> addOrder(
      String id, String date, String status, String totalPrice) async {
    String respone = 'Error';
    model.Order order =
        model.Order(id: id, date: date, status: status, totalPrice: totalPrice);
    try {
      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('orders')
          .doc(id)
          .set(order.toJson());

      var foodSnap = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('carts')
          .get();
      for (int i = 0; i < foodSnap.size; i++) {
        await _firestore
            .collection('users')
            .doc(_firebaseAuth.currentUser!.uid)
            .collection('orders')
            .doc(id)
            .collection('foods')
            .doc(foodSnap.docs[i].data()['id'])
            .set({
          'id': foodSnap.docs[i].data()['id'],
          'name': foodSnap.docs[i].data()['name'],
          'describe': foodSnap.docs[i].data()['describe'],
          'price': foodSnap.docs[i].data()['price'],
          'salePrice': foodSnap.docs[i].data()['salePrice'],
          'image': foodSnap.docs[i].data()['image'],
          'quantity': foodSnap.docs[i].data()['quantity'],
          'totalPrice': foodSnap.docs[i].data()['totalPrice']
        });
      }

      String notiID = Uuid().v1();
      String date = DateTime.now().toString();
      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('notifications')
          .doc(notiID)
          .set({
        'id': notiID,
        'date': date,
        'content': 'Ordering success, food is being delivered to your address!',
      });
      respone = 'Success';

      //TODO: Clear cart after paying
      //await _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).collection('carts').doc(foodSnap.docs[i].data()['id']).delete();
    } catch (e) {
      print(e);
    }
    return respone;
  }
}
