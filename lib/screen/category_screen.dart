import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/controller/cate_controller.dart';
import 'package:food_order_app/screen/cart_screen.dart';
import 'package:food_order_app/util/color.dart';
import 'package:food_order_app/widget/food_card.dart';
import 'package:food_order_app/widget/order_cate_card.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CategoryScreen> {
  final CateController cateController = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeBgColor,
        centerTitle: true,
        title: const Text(
          'Order',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: primaryColor,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Get.to(() => CartScreen());
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  color: primaryColor,
                ),
              ),
              Positioned(
                left: 32,
                top: 1,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('carts')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      num totalQuantity = 0;
                      for(int i = 0;i<snapshot.data!.size;i++){
                        totalQuantity = totalQuantity + snapshot.data!.docs[i].data()['quantity'];
                      }
                      return Container(
                        padding: const EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: primaryColor
                        ),
                        child: Text(
                          totalQuantity.toString(),
                          style: TextStyle(color: ThemeBgColor, fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return const Text(
                      '0',
                      style: TextStyle(color: primaryColor),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container(
                  width: double.infinity,
                  height: 50,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          cateController.updateCate(
                              snapshot.data!.docs[index].data()['categoryID']);
                        },
                        child: OrderCateCard(
                            cateName: snapshot.data!.docs[index]
                                .data()['categoryName']),
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                    scrollDirection: Axis.horizontal,
                  ),
                );
              },
            ),
            Expanded(
              child: GetBuilder<CateController>(builder: (_) {
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .doc(cateController.cateID)
                      .collection('foods')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.5,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return FoodCard(
                          id: snapshot.data!.docs[index].data()['id'],
                          name: snapshot.data!.docs[index].data()['name'],
                          imgUrl: snapshot.data!.docs[index].data()['image'],
                          price: snapshot.data!.docs[index].data()['price'],
                          salePrice:
                              snapshot.data!.docs[index].data()['salePrice'],
                          describe:
                              snapshot.data!.docs[index].data()['describe'],
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
//
