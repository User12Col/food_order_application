import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/model/food.dart';
import 'package:food_order_app/repository/food_repository.dart';
import 'package:food_order_app/util/color.dart';
import 'package:food_order_app/widget/food_detail_dialog.dart';
import 'package:get/get.dart';

class FoodCard extends StatelessWidget {
  String id;
  String name;
  String imgUrl;
  String price;
  String salePrice;
  String describe;
  FoodCard(
      {Key? key,
      required this.id,
      required this.name,
      required this.imgUrl,
      required this.price,
      required this.salePrice,
      required this.describe})
      : super(key: key);

  _addToCart() async {
    Food food = Food(
        id: id,
        name: name,
        describe: '',
        price: price,
        salePrice: salePrice,
        image: imgUrl);

    await FoodRepository().addToCart(food);
  }

  _removeFromCart() async {
    await FoodRepository().decreaseQuantity(id);
  }

  Future<int> _getQuantity() async {
    var snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('carts')
        .doc(id)
        .get();
    if (snap.exists) {
      return snap.data()!['quantity'];
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => FoodDetailDialog(
              id: id,
              name: name,
              describe: describe,
              imgUrl: imgUrl,
              salePrice: salePrice,
              price: price,
            ));
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.all(4.0),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: primaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: NetworkImage(imgUrl),
              width: 100,
              height: 100,
            ),
            Text(
              name,
              textAlign: TextAlign.center,
            ),
            Text(
              price,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: ThemeBgColor),
            ),
            salePrice.isEmpty
                ? Text('')
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.discount,
                        size: 12,
                        color: ThemeBgColor,
                      ),
                      Text(
                        salePrice,
                        style: TextStyle(
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _removeFromCart,
                  icon: Icon(Icons.remove),
                  color: ThemeBgColor,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('carts')
                      .doc(id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.data!.exists) {
                        return Text(
                            snapshot.data!.data()!['quantity'].toString());
                      } else {
                        return Text('0');
                      }
                    }
                  },
                ),
                IconButton(
                  onPressed: _addToCart,
                  icon: Icon(Icons.add),
                  color: ThemeBgColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
