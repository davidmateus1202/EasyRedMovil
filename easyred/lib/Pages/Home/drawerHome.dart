import 'package:easyred/Firebase/Authentication.dart';
import 'package:easyred/Firebase/FirebaseUtils.dart';
import 'package:easyred/Pages/AuthUsers/LoginPage.dart';
import 'package:easyred/Pages/Home/ChatRoom/ChatPage.dart';
import 'package:easyred/Pages/Home/Feed/HomePage.dart';
import 'package:easyred/Pages/Home/Profile/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';

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
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              color: HexColor('B401FF'),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      Provider.of<FirebaseUtils>(context, listen: false)
                              .initUserAvatar ??
                          ''),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  Provider.of<FirebaseUtils>(context, listen: false)
                          .initUsername ??
                      '',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                )
              ],
            ),
          ),
          Image(
            image: AssetImage('assets/images/onda.png'),
            fit: BoxFit.cover,
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: HexColor('8E32BE'),
            ),
            title: Text(
              'Home',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: HexColor('8E32BE'),
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: HomePage(),
                      type: PageTransitionType.rightToLeftWithFade));
            },
          ),
          Divider(
            height: 10,
            thickness: 0.3,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            leading: Icon(Icons.person, color: HexColor('8E32BE')),
            title: Text('Profile',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: HexColor('8E32BE'),
                )),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: ProfilePage(),
                      type: PageTransitionType.rightToLeftWithFade));
            },
          ),
          Divider(
            height: 10,
            thickness: 0.3,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            leading: Icon(Icons.chat, color: HexColor('8E32BE')),
            title: Text('Chat',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: HexColor('8E32BE'),
                )),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: ChatPage(),
                      type: PageTransitionType.rightToLeftWithFade));
            },
          ),
          Divider(
            height: 10,
            thickness: 0.3,
            indent: 16,
            endIndent: 16,
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                color: HexColor('B401FF'),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
                title: const Text('Logout',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    )),
                onTap: () async {
                  await Provider.of<AuthenticationServices>(context,
                          listen: false)
                      .logout()
                      .whenComplete(() {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: LoginPage(),
                            type: PageTransitionType.rightToLeftWithFade));
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
