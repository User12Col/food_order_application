import 'package:food_order_app/model/user.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  User ?_user;

  User get user => _user!;

  void updateUser(User newUser){
    _user = newUser;
    update();
  }
}