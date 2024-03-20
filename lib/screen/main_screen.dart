import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/controller/user_controller.dart';
import 'package:food_order_app/screen/account_screen.dart';
import 'package:food_order_app/screen/home_screen.dart';
import 'package:food_order_app/screen/noti_screen.dart';
import 'package:food_order_app/screen/category_screen.dart';
import 'package:food_order_app/util/color.dart';
import 'package:get/get.dart';

import '../controller/cate_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserController userController = Get.find();
  CateController cateController = Get.put(CateController());
  final PageController _pageController = PageController();
  int _page = 0;

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void jumpToPage(int page) {
    _pageController.jumpToPage(page);
  }

  _onViewAllPressed(){
    _pageController.jumpToPage(1);
    cateController.updateCate('IreZtPscLsz1CdcN55qT');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          HomeScreen(onViewAllPressed: _onViewAllPressed,),
          CategoryScreen(),
          NotiScreen(),
          AccountScreen(),
        ],
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: primaryColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0 ? ThemeBgColor : fontColor,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.fastfood,
                color: _page == 1 ? ThemeBgColor : fontColor,
              ),
              label: 'Order'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                color: _page == 2 ? ThemeBgColor : fontColor,
              ),
              label: 'Notification'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.manage_accounts,
                color: _page == 3 ? ThemeBgColor : fontColor,
              ),
              label: 'Account'),
        ],
        onTap: jumpToPage,
      ),
    );
  }
}
