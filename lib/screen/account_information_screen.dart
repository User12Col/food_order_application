import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_order_app/controller/user_controller.dart';
import 'package:food_order_app/model/user.dart' as model;
import 'package:food_order_app/repository/user_repository.dart';
import 'package:food_order_app/screen/account_screen.dart';
import 'package:food_order_app/util/color.dart';
import 'package:food_order_app/validate/validate.dart';
import 'package:get/get.dart';
class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({Key? key}) : super(key: key);

  @override
  State<AccountInformationScreen> createState() => _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  final UserController _userController = Get.find();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  final PageController _pageController = PageController();

  TextStyle titleStyle = const TextStyle(fontWeight: FontWeight.bold);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fullNameController.text = _userController.user.fullName;
    _phoneController.text = _userController.user.phoneNumber;
    _emailController.text = _userController.user.email;
  }

  void _updateUserController(String id, String fullName, String email, String phoneNumber, String password, String address){
    model.User user = model.User(id: id, fullName: fullName, email: email, phoneNumber: phoneNumber, password: password, address: address, order: [], cart: []);
    _userController.updateUser(user);
  }

  void _updateUserInformation() async{
    if(Validate.isEmpty(_fullNameController.text) || Validate.isEmpty(_phoneController.text) || Validate.isEmpty(_emailController.text)){
      Fluttertoast.showToast(
        msg: 'Field cant be empty',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
    } else if(!Validate.isEmpty(_oldPassController.text) && !Validate.isEmpty(_newPassController.text) && !Validate.isEmpty(_confirmPassController.text) ){
      String updateUserResult = await UserRepository().updateUserInformation(_fullNameController.text, _phoneController.text, _emailController.text);
      if(await UserRepository().isPassword(_oldPassController.text)){
        if(Validate.isMatchPassword(_newPassController.text, _confirmPassController.text)){
          String updatePassword = await UserRepository().updatePassword(_newPassController.text);
          _updateUserController(FirebaseAuth.instance.currentUser!.uid, _fullNameController.text, _emailController.text, _phoneController.text, _newPassController.text, _userController.user.address);
          Get.back();
        } else{
          Fluttertoast.showToast(
            msg: 'Password doesnt match',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
          );
        }
      } else{
        Fluttertoast.showToast(
          msg: 'Invalid password',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
      }
    } else{
      String updateUserResult = await UserRepository().updateUserInformation(_fullNameController.text, _phoneController.text, _emailController.text);
      _updateUserController(FirebaseAuth.instance.currentUser!.uid, _fullNameController.text, _emailController.text, _phoneController.text, _userController.user.password, _userController.user.address);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Account Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Full name *', style: titleStyle,),
                TextField(
                  controller: _fullNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(

                  ),
                ),
                const SizedBox(height: 18,),
                Text('Phone number *', style: titleStyle,),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(

                  ),
                ),
                const SizedBox(height: 18,),
                Text('Email *', style: titleStyle,),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(

                  ),
                ),
                const SizedBox(height: 18,),
                Text('Old password *', style: titleStyle,),
                TextField(
                  controller: _oldPassController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(

                  ),
                ),
                const SizedBox(height: 18,),
                Text('New password *', style: titleStyle,),
                TextField(
                  controller: _newPassController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(

                  ),
                ),
                const SizedBox(height: 18,),
                Text('New password again *', style: titleStyle,),
                TextField(
                  controller: _confirmPassController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(

                  ),
                ),
                const SizedBox(height: 18,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                      color: ThemeBgColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: InkWell(
                    child: const Center(
                      child: Text(
                        'Update',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                    ),
                    onTap: _updateUserInformation,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
