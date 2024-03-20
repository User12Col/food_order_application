import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/controller/user_controller.dart';
import 'package:food_order_app/util/color.dart';
import 'package:food_order_app/widget/food_order_card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  String id;
  OrderDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController _userController = Get.find();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Order Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(color: primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CUSTOMER INFORMATION',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_userController.user.fullName),
                      Text(_userController.user.email),
                      Text(_userController.user.phoneNumber),
                      const Row(
                        children: [
                          Icon(
                            Icons.maps_home_work,
                            color: ThemeBgColor,
                          ),
                          Text(
                            'Deliver to:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Text(_userController.user.address),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                const Text(
                  'ORDER INFORMATION',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('orders')
                        .doc(id)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID: ${snapshot.data!.data()!['id']}',
                            style: TextStyle(
                                color: ThemeBgColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                              'Date: ${DateFormat('dd-MM-yyyy hh:mm:ss').format(DateTime.parse(snapshot.data!.data()!['date']))}'),
                          const Divider(
                            color: ThemeBgColor,
                          ),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('orders')
                                .doc(id)
                                .collection('foods')
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return FoodOrderCard(
                                        name: snapshot.data!.docs[index]
                                            .data()['name'],
                                        quantity: snapshot.data!.docs[index]
                                            .data()['quantity']
                                            .toString(),
                                        totalPrice: snapshot.data!.docs[index]
                                            .data()['totalPrice']);
                                  },
                                  itemCount: snapshot.data!.docs.length,
                                ),
                              );
                            },
                          ),
                          const Divider(color: ThemeBgColor,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total price:'),
                              Text(snapshot.data!.data()!['totalPrice'], style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Ship fee:'),
                              Text('0', style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                      color: ThemeBgColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: InkWell(
                    child: const Center(
                      child: Text(
                        'Order Again',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                    ),
                    onTap: (){},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
