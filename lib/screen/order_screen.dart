import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/controller/status_controller.dart';
import 'package:food_order_app/controller/user_controller.dart';
import 'package:food_order_app/screen/order_detail_screen.dart';
import 'package:food_order_app/widget/order_card.dart';
import 'package:food_order_app/widget/order_status_card.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final StatusController _statusController = Get.put(StatusController());
  final UserController _userController = Get.find();
  List listTitle = ['Delivering', 'Delivered'];
  List listIcon = [Icons.motorcycle, Icons.check_circle];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Information',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Container(
                height: 100,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        _statusController.updateStatus(listTitle[index]);
                      },
                      child: OrderStatusCard(
                          title: listTitle[index], icon: listIcon[index]),
                    );
                  },
                  itemCount: listTitle.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Expanded(
                child: GetBuilder<StatusController>(
                  builder: (_) {
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('orders')
                          .where('status', isEqualTo: _statusController.status)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (!snapshot.hasData) {
                          return const Center(
                            child: Text('No data found!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                          );
                        }
                        return ListView.separated(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){
                                  Get.to(()=>OrderDetailScreen(id: snapshot.data!.docs[index].data()['id'],));
                                },
                                child: OrderCard(
                                    id: snapshot.data!.docs[index].data()['id'],
                                    date:
                                        snapshot.data!.docs[index].data()['date'],
                                    address: _userController.user.address,
                                    status: snapshot.data!.docs[index]
                                        .data()['status']),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: snapshot.data!.docs.length);
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
