import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String id;
  String date;
  String status;
  String totalPrice;

  Order(
      {required this.id,
      required this.date,
      required this.status,
      required this.totalPrice});

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "status": status,
        "totalPrice": totalPrice,
      };

  static Order fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Order(
      id: snap["id"],
      date: snap["date"],
      status: snap["status"],
      totalPrice: snap["totalPrice"],
    );
  }
}
