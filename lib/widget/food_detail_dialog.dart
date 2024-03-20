import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/model/food.dart';
import 'package:food_order_app/repository/food_repository.dart';
import 'package:food_order_app/util/color.dart';
import 'package:get/get.dart';

class FoodDetailDialog extends StatefulWidget {
  String id;
  String name;
  String imgUrl;
  String price;
  String salePrice;
  String describe;
  FoodDetailDialog(
      {Key? key,
      required this.id,
      required this.name,
      required this.imgUrl,
      required this.price,
      required this.salePrice,
      required this.describe})
      : super(key: key);

  @override
  State<FoodDetailDialog> createState() => _FoodDetailDialogState();
}

class _FoodDetailDialogState extends State<FoodDetailDialog> {
  _addToCart() async {
    Food food = Food(
        id: widget.id,
        name: widget.name,
        describe: widget.describe,
        price: widget.price,
        salePrice: widget.salePrice,
        image: widget.imgUrl);

    await FoodRepository().addToCart(food);
  }

  _removeFromCart() async {
    await FoodRepository().decreaseQuantity(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    List<String> listDescribe = widget.describe.split(",");
    return MediaQuery.removePadding(
      removeBottom: true,
      context: context,
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Image(
                          image: NetworkImage(widget.imgUrl),
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                        ),
                        const SizedBox(height: 18,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.price,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ThemeBgColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Text(listDescribe[index]);
                            },
                            itemCount: listDescribe.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                height: 50,
                decoration: const BoxDecoration(color: primaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                              .doc(widget.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              if (snapshot.data!.exists) {
                                return Text(snapshot.data!
                                    .data()!['quantity']
                                    .toString());
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
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 40,
                      decoration: BoxDecoration(
                          color: ThemeBgColor,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: InkWell(
                        child: const Center(
                          child: Text(
                            'Add to cart',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                        ),
                        onTap: _addToCart,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
