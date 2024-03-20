import 'package:get/get.dart';

class AddressController extends GetxController{
  String _address = 'Your address';
  String get address => _address;

  void updateAddress(String address){
    _address = address;
    update();
  }
}