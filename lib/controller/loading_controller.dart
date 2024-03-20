import 'package:get/get.dart';

class LoadingController extends GetxController{
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setTrue(){
    _isLoading = true;
    update();
  }

  void setFalse(){
    _isLoading = false;
    update();
  }
}