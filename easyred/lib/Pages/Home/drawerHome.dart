import 'package:easyred/Firebase/Authentication.dart';
import 'package:easyred/Pages/AuthUsers/LoginPage.dart';
import 'package:easyred/Pages/Home/Feed/HomePage.dart';
import 'package:easyred/Pages/Home/Profile/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class DrawerHome extends StatefulWidget {
  const DrawerHome({super.key});

  @override
  State<DrawerHome> createState() => _DrawerHomeState();
}

class _DrawerHomeState extends State<DrawerHome> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: HomePage(),
                      type: PageTransitionType.rightToLeftWithFade));
            },
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: ProfilePage(),
                      type: PageTransitionType.rightToLeftWithFade));
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Provider.of<AuthenticationServices>(context, listen: false)
                  .logout()
                  .whenComplete(() {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: LoginPage(),
                        type: PageTransitionType.rightToLeftWithFade));
              });
            },
          )
        ],
      ),
    );
  }
}
