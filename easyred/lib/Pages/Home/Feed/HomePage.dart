import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyred/Firebase/Authentication.dart';
import 'package:easyred/Firebase/FirebaseUtils.dart';
import 'package:easyred/Pages/Home/Feed/PostPage.dart';
import 'package:easyred/Pages/Home/drawerHome.dart';
import 'package:easyred/Utils/ContainerPost.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<FirebaseUtils>(context, listen: false).initUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerHome(),
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FloatingActionButton(
                elevation: 0,
                mini: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36)),
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: PostPage(),
                          type: PageTransitionType.leftToRightWithFade));
                },
                child: Icon(
                  Icons.camera,
                  color: HexColor('9A0EE2'),
                ),
              ),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Post')
              .orderBy('time', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error al cargar los datos',
                  style: TextStyle(
                      color: HexColor('9A0EE2'),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset(
                  'assets/images/loading.gif',
                  height: 50,
                  width: 50,
                ),
              );
            }
            return SingleChildScrollView(
                child: Column(
              children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return ContainerPost(data: data);
              }).toList(),
            ));
          },
        ));
  }
}
