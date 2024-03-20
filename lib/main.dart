import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/controller/loading_controller.dart';
import 'package:food_order_app/controller/user_controller.dart';
import 'package:food_order_app/screen/login_screen.dart';
import 'package:food_order_app/screen/main_screen.dart';
import 'package:food_order_app/screen/order_screen.dart';
import 'package:food_order_app/screen/result_screen.dart';
import 'package:food_order_app/screen/splash_screen.dart';
import 'package:food_order_app/util/color.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAqzxodJprghatIxPk2O5U4wATZawYREsA",
          authDomain: "foodapp-7618f.firebaseapp.com",
          projectId: "foodapp-7618f",
          storageBucket: "foodapp-7618f.appspot.com",
          messagingSenderId: "384980332089",
          appId: "1:384980332089:web:ebbef259751794ece7e7e8",
          measurementId: "G-NTMTNLVR15",
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  _checkLoggedIn() async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    return prefs.getStringList('users ');
  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    LoadingController loadingController = Get.put(LoadingController());
    return GetMaterialApp(
      title: 'Order Food',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: mobileBgColor,
      ),
      home: SplashScreen(),
    );
  }
}

/*
* GetBuilder<UserController>(
*   builder:(_){
*     return Container();
*   }
* )
*
* */

