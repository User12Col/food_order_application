import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_order_app/controller/loading_controller.dart';
import 'package:food_order_app/controller/user_controller.dart';
import 'package:food_order_app/repository/user_repository.dart';
import 'package:food_order_app/screen/main_screen.dart';
import 'package:food_order_app/screen/signup_screen.dart';
import 'package:food_order_app/util/color.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserController userController = Get.find();
  LoadingController loadingController = Get.find();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  void login() async {
    loadingController.setTrue();
    String email = _emailController.text;
    String password = _passController.text;

    String res =
        await UserRepository().signinWithEmailAndPassword(email, password);

    if (res != 'Login Success') {
      Fluttertoast.showToast(
        msg: 'Error when login',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
    } else {
      User user = await UserRepository().getUserDetails();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('users', <String>[user.id, user.address, user.phoneNumber, user.email, user.fullName, user.password]);
      userController.updateUser(user);
      Get.to(() => MainScreen());
    }
    loadingController.setFalse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<LoadingController>(
        builder: (_) {
          return SafeArea(
            child: loadingController.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Login or Create new account',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 26),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            focusColor: ThemeBgColor,
                            hintText: 'Enter you email',
                            filled: true,
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextField(
                          controller: _passController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Enter you password',
                            filled: true,
                            contentPadding: EdgeInsets.all(8),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 24,
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
                                'Login',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                              ),
                            ),
                            onTap: login,
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Dont have account? ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ThemeBgColor),
                              ),
                              onTap: () {
                                Get.to(() => SignUpScreen());
                              },
                            ),

                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text(
                          'Or login by: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.g_mobiledata)),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.facebook)),
                          ],
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
