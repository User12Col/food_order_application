import 'package:get/get.dart';

class StatusController extends GetxController{
  String _status = 'Delivering';
  String get status => _status;

  void updateStatus (String status){
    _status = status;
    update();
  }

}