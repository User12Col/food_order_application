import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_order_app/controller/user_controller.dart';
import 'package:food_order_app/repository/user_repository.dart';
import 'package:food_order_app/screen/login_screen.dart';
import 'package:food_order_app/screen/main_screen.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserController _userController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTimer();

  }

  void _startTimer(){
    Timer(Duration(seconds: 2), () {
      _navigateUser();
    });
  }

  void _navigateUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? items = sharedPreferences.getStringList('users');
    if(items != null){
      String res = await UserRepository().signinWithEmailAndPassword(items[3], items[5]);
      User user = await UserRepository().getUserDetails();
      _userController.updateUser(user);
      Get.to(()=>MainScreen());
    } else{
      Get.to(()=>LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.network('https://lottie.host/fc52d3c0-32f7-41b3-b1e1-38223b675066/f0pIFVW1TK.json'),
      ),
    );
  }
}
