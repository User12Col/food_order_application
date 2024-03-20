import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/screen/address_screen.dart';
import 'package:food_order_app/screen/cart_screen.dart';
import 'package:food_order_app/screen/category_screen.dart';
import 'package:food_order_app/util/color.dart';
import 'package:food_order_app/widget/food_card.dart';
import 'package:food_order_app/widget/home_cate_card.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onViewAllPressed;
  HomeScreen({Key? key, required this.onViewAllPressed}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List cates = ['HOME', 'ORDER', 'SALE', 'STORE'];
  List catesIcon = [
    Icons.chat,
    Icons.fastfood,
    Icons.price_change_rounded,
    Icons.store
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeBgColor,
        centerTitle: true,
        title: const Text(
          'Home',
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
                icon: Icon(
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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: primaryColor,
                ),
                child: ListTile(
                  onTap: () {
                    Get.to(() => AddressScreen());
                  },
                  leading: const Icon(
                    Icons.maps_home_work,
                    color: ThemeBgColor,
                  ),
                  title: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.data!.data()!['address'] == '') {
                          return const Text(
                            'Your address',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text(
                            snapshot.data!.data()!['address'],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          );
                        }
                      }),
                  subtitle: const Text('Tap to choose your address'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 180,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2,
                  ),
                  itemCount: cates.length,
                  itemBuilder: (context, index) {
                    return HomeCateCard(
                      title: cates[index],
                      icon: catesIcon[index],
                    );
                  },
                ),
              ),
              ListTile(
                onTap: widget.onViewAllPressed,
                title: const Text(
                  'SPECIAL OFFERS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: fontColor,
                  ),
                ),
                trailing: const Text(
                  'View all',
                  style: TextStyle(color: ThemeBgColor, fontSize: 12),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .doc('IreZtPscLsz1CdcN55qT')
                      .collection('foods')
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container(
                      constraints: const BoxConstraints(
                        minHeight: 250,
                        maxHeight: 300,
                      ),
                      width: double.infinity,
                      child: ListView.builder(
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
                        scrollDirection: Axis.horizontal,
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
