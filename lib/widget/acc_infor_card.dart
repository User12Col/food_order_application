import 'package:flutter/material.dart';
import 'package:food_order_app/controller/user_controller.dart';
import 'package:food_order_app/util/color.dart';
import 'package:get/get.dart';
class AccountInformationCard extends StatelessWidget {
  const AccountInformationCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController _userController = Get.find();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(8.0),
        color: primaryColor
      ),
      child: GetBuilder<UserController>(
        builder: (_){
          return Column(
            children: [
              ListTile(leading: const Icon(Icons.manage_accounts_rounded, color: ThemeBgColor,), title: Text('Name: ${_userController.user.fullName}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),),
              ListTile(leading: const Icon(Icons.cake, color: ThemeBgColor,), title: Text('DoB: ${_userController.user.id}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),),
              ListTile(leading: const Icon(Icons.phone_android, color: ThemeBgColor,), title: Text('Phone: ${_userController.user.phoneNumber}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),),
              ListTile(leading: const Icon(Icons.mail, color: ThemeBgColor,), title: Text('Email: ${_userController.user.email}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),),
            ],
          );
        },
      ),
    );
  }
}
