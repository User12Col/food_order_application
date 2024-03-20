import 'package:flutter/material.dart';
import 'package:food_order_app/controller/user_controller.dart';
import 'package:food_order_app/screen/account_information_screen.dart';
import 'package:food_order_app/screen/address_screen.dart';
import 'package:food_order_app/screen/login_screen.dart';
import 'package:food_order_app/screen/order_screen.dart';
import 'package:food_order_app/util/color.dart';
import 'package:food_order_app/widget/acc_infor_card.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<AccountScreen> {
  UserController _userController = Get.find();

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('users');
    Get.to(()=>LoginScreen());
  }

  Future<void> launchFacebook(String page) async {
    String facebookUrl = 'https://www.facebook.com/$page';
    Uri facebookUri = Uri.parse(facebookUrl);

    if (await canLaunchUrl(facebookUri)) {
      await launchUrl(facebookUri);
    } else {
      throw 'Could not launch $facebookUrl';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeBgColor,
        centerTitle: true,
        title: const Text(
          'Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                  color: ThemeBgColor,
                ),
                child: GetBuilder<UserController>(
                  builder: (_){
                    return Text(_userController.user.fullName, style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),);
                  },
                ),
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: categoryBgColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Account Information',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      onTap: (){
                        Get.to(()=>AccountInformationScreen());
                      },
                      trailing: const Text(
                        'Edit',
                        style: TextStyle(color: ThemeBgColor, fontSize: 12),
                      ),
                    ),
                    const AccountInformationCard(),
                    ListTile(
                      onTap: (){
                        Get.to(()=>AddressScreen());
                      },
                      leading: Icon(Icons.location_on,),
                      title: const Text(
                        'Location',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    const Divider(height: 0,),
                    ListTile(
                      onTap: (){
                        Get.to(()=>OrderScreen());
                      },
                      leading: Icon(Icons.add_business,),
                      title: const Text(
                        'Order Detail',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    const Divider(height: 0,),
                    ListTile(
                      onTap: () async{
                        await launchFacebook('votrantan.loc');
                      },
                      leading: Icon(Icons.chat_bubble,),
                      title: const Text(
                        'Help',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    const Divider(height: 0,),
                    ListTile(
                      onTap: _logout,
                      leading: Icon(Icons.logout,),
                      title: const Text(
                        'Log out',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    const Divider(height: 0,),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Contact: votrantanloc140@gmail.com', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(onPressed: (){}, icon: Icon(Icons.facebook, color: Colors.blue,)),
                              IconButton(onPressed: (){}, icon: Icon(Icons.g_mobiledata, color: Colors.red,)),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
