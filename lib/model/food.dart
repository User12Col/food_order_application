import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  String id;
  String name;
  String describe;
  String price;
  String salePrice;
  String image;

  Food({required this.id, required this.name, required this.describe, required this.price, required this.salePrice, required this.image});

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "describe": describe,
    "price": price,
    "salePrice": salePrice,
    "image": image,
  };

  static Food fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Food(
        id: snap["id"],
        name: snap["name"],
        describe: snap["describe"],
        price: snap["price"],
        salePrice: snap["salePrice"],
        image: snap["image"]);
  }
}