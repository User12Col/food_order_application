import 'package:flutter/material.dart';
class FoodOrderCard extends StatelessWidget {
  String name;
  String quantity;
  String totalPrice;
  FoodOrderCard({Key? key, required this.name, required this.quantity, required this.totalPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(quantity),
          Text(name, style: TextStyle(fontWeight: FontWeight.bold),),
          Text(totalPrice),
        ],
      ),
    );
  }
}
