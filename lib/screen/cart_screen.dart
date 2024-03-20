import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_order_app/controller/user_controller.dart';
import 'package:food_order_app/screen/pay_screen.dart';
import 'package:food_order_app/util/color.dart';
import 'package:food_order_app/widget/cart_card.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final UserController _userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('carts')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('No items in the cart'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return CartCard(
                        id: snapshot.data!.docs[index].data()['id'],
                        name: snapshot.data!.docs[index].data()['name'],
                        imgUrl: snapshot.data!.docs[index].data()['image'],
                        price: snapshot.data!.docs[index].data()['price'],
                        salePrice:
                            snapshot.data!.docs[index].data()['salePrice'],
                        quantity: snapshot.data!.docs[index].data()['quantity'],
                        totalPrice:
                            snapshot.data!.docs[index].data()['totalPrice'],
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              height: 100,
              decoration: const BoxDecoration(
                color: primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total price: '),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('carts')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data!.size == 0) {
                              return const Text(
                                '0',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ThemeBgColor),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator(),);
                            } else {
                              int total = 0;
                              for (int i = 0; i < snapshot.data!.size; i++) {
                                total = total +
                                    int.parse(snapshot.data!.docs[i]
                                        .data()['totalPrice']);
                              }
                              return Text(
                                total.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ThemeBgColor),
                              );
                            }
                          }),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    decoration: BoxDecoration(
                        color: ThemeBgColor,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: InkWell(
                      child: const Center(
                        child: Text(
                          'Pay',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                      ),
                      onTap: () {
                        if(_userController.user.address.isEmpty){
                          Fluttertoast.showToast(
                            msg: 'Choose your address before ordering',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: ThemeBgColor,
                            textColor: Colors.white,
                          );
                        } else{
                          Get.to(()=>PayScreen());
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
