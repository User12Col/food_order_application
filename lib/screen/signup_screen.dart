import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_order_app/controller/loading_controller.dart';
import 'package:food_order_app/controller/user_controller.dart';
import 'package:food_order_app/repository/user_repository.dart';
import 'package:food_order_app/screen/main_screen.dart';
import 'package:food_order_app/util/color.dart';
import 'package:get/get.dart';

import '../model/user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  UserController userController = Get.find();
  LoadingController loadingController = Get.find();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _cfPassController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _cfPassController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
  }

  void signUpUser() async {
    loadingController.setTrue();
    String email = _emailController.text;
    String pass = _passController.text;
    String cfPass = _cfPassController.text;
    String fullName = _fullNameController.text;
    String phone = _phoneController.text;

    String res = await UserRepository().createUserWithEmailAndPassword(
        email, pass, cfPass, fullName, phone, '');

    if (res != 'Success') {
      Fluttertoast.showToast(
        msg: 'Error when signing up user',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
    } else {
      User user = await UserRepository().getUserDetails();
      userController.updateUser(user);
      Get.to(() => MainScreen());
    }
    loadingController.setFalse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<LoadingController>(builder: (_) {
        return SafeArea(
          child: loadingController.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: primaryColor,
                ))
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Create new account',
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
                          hintText: 'Enter your email',
                          filled: true,
                          contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextField(
                        controller: _fullNameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          focusColor: ThemeBgColor,
                          hintText: 'Enter your full name',
                          filled: true,
                          contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          focusColor: ThemeBgColor,
                          hintText: 'Enter your phone number',
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
                          hintText: 'Enter your password',
                          filled: true,
                          contentPadding: EdgeInsets.all(8),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextField(
                        controller: _cfPassController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'Enter your password again',
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
                          child: Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                          ),
                          onTap: signUpUser,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have account? ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            child: const Text(
                              'Login ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ThemeBgColor),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      const Text(
                        'to use app',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
