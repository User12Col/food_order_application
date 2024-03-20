import 'package:flutter/material.dart';
import 'package:food_order_app/util/color.dart';
import 'package:intl/intl.dart';
class NotificationCard extends StatelessWidget {
  String date;
  String content;
  NotificationCard({Key? key, required this.date, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: primaryColor
      ),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: ThemeBgColor,),
          const SizedBox(width: 20,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(content, style: const TextStyle(fontWeight: FontWeight.bold), softWrap: true,),
                const SizedBox(height: 5,),
                Text(DateFormat('dd-MM-yyyy hh:mm:ss').format(DateTime.parse(date)), style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),),
              ],
            ),
          )
        ],
      ),
    );
  }
}
