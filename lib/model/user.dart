import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String fullName;
  String email;
  String phoneNumber;
  String password;
  String address;
  List order;
  List cart;

  User(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.phoneNumber,
      required this.password,
      required this.address,
      required this.order,
      required this.cart});

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "address": address,
        "order": [],
        "cart": []
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return User(
        id: snap["id"],
        fullName: snap["fullName"],
        email: snap["email"],
        phoneNumber: snap["phoneNumber"],
        password: snap["password"],
        address: snap["address"],
        order: snap["order"],
        cart: snap["cart"]);
  }
}
