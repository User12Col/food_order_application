import 'package:get/get.dart';

class CateController extends GetxController{
  String _cateID = 'BSuUcC8ELv4JSnJPyXux';

  String get cateID => _cateID!;

  void updateCate(String cateID){
    _cateID = cateID;
    update();
    print(_cateID);
  }

}