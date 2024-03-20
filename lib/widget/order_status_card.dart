import 'package:flutter/material.dart';
import 'package:food_order_app/util/color.dart';
class OrderStatusCard extends StatelessWidget {
  String title;
  IconData icon;
  OrderStatusCard({Key? key, required this.title, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Icon(icon, color: ThemeBgColor, size: 50,),
          Text(title),
        ],
      ),
    );
  }
}
