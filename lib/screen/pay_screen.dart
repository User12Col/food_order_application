import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_order_app/controller/user_controller.dart';
import 'package:food_order_app/repository/order_repository.dart';
import 'package:food_order_app/screen/result_screen.dart';
import 'package:food_order_app/util/color.dart';
import 'package:food_order_app/widget/cart_card.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
class PayScreen extends StatefulWidget {
  const PayScreen({Key? key}) : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  final UserController _userController = Get.find();
  int _total = 0;

  _addOrder() async{
    String id = Uuid().v1();
    String date = DateTime.now().toString();
    String status = 'Delivering';
    String totalPrice = _total.toString();

    String result = await OrderRepository().addOrder(id, date, status, totalPrice);

    if(result == 'Success'){
      Get.to(()=>ResultScreen());
    } else{
      Fluttertoast.showToast(
        msg: 'Error when paying, try later!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeBgColor,
        centerTitle: true,
        title: const Text(
          'Pay',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: primaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Delivery to'),
                          Text(_userController.user.address, style: const TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ORDER INFORMATION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                        InkWell(
                          onTap: (){},
                          child: const Text(
                            'Add more',
                            style: TextStyle(color: ThemeBgColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 300,
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
                    const SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.fastfood, color: ThemeBgColor, size: 20,),
                        title: const Text('Plastic eating utensils', style: TextStyle(fontSize: 12),),
                        trailing: Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            activeColor: ThemeBgColor,
                            value: true,
                            onChanged: (value){},
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    const Text('PAY INFORMATION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Price'),
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
                                },
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Ship Fee'),
                              Text('0'),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            height: 80,
            decoration: BoxDecoration(
              color: primaryColor
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Total price', style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
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
                          //int total = 0;
                          for (int i = 0; i < snapshot.data!.size; i++) {
                            _total = _total +
                                int.parse(snapshot.data!.docs[i]
                                    .data()['totalPrice']);
                          }
                          return Text(
                            _total.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ThemeBgColor),
                          );
                        }
                      },
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  height: 40,
                  decoration: BoxDecoration(
                      color: ThemeBgColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: InkWell(
                    child: const Center(
                      child: Text(
                        'Pay',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                    ),
                    onTap: _addOrder,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
