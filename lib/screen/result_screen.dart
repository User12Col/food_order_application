import 'package:flutter/material.dart';
import 'package:food_order_app/screen/main_screen.dart';
import 'package:food_order_app/util/color.dart';
import 'package:get/get.dart';
class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                children: [
                  Icon(Icons.check_circle, color: ThemeBgColor, size: 200.0,),
                  Text('Your food is being prepared to deliver. Thanks!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                    color: ThemeBgColor,
                    borderRadius: BorderRadius.circular(8.0)),
                child: InkWell(
                  child: const Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                  ),
                  onTap: (){
                    Get.to(()=>MainScreen());
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
