import 'package:flutter/material.dart';
import 'package:food_order_app/util/color.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  String id;
  String date;
  String address;
  String status;
  OrderCard ({Key? key, required this.id, required this.date, required this.address, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ID: #$id', overflow: TextOverflow.ellipsis, softWrap: true, style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Date: ${DateFormat('dd-MM-yyyy hh:mm:ss').format(DateTime.parse(date))}', style: TextStyle(fontWeight: FontWeight.bold)),
          const Row(
            children: [
              Icon(Icons.maps_home_work, color: ThemeBgColor,),
              Text('Deliver to:', style: TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
          Text(address),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(status, style: const TextStyle(color: Colors.green, fontStyle: FontStyle.italic),),
            ],
          )
        ],
      ),
    );
  }
}
