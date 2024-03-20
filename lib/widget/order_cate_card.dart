import 'package:flutter/material.dart';
import 'package:food_order_app/util/color.dart';
class OrderCateCard extends StatelessWidget {
  String cateName;
  OrderCateCard({Key? key, required this.cateName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      width: 100,
      child: Center(
        child: Text(
          cateName,
        ),
      ),
    );
  }
}
