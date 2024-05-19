import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyred/Pages/Home/drawerHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        title: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
                text: TextSpan(
                    text: 'Social',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: HexColor('AF33E1')))),
            RichText(
                text: TextSpan(
                    text: ' Chat',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: HexColor('FFD700')))),
          ],
        )),
      ),
      drawer: DrawerHome(),
      body: _builderUserList(),
    );
  }

  Widget _builderUserList(DocumentSnapshot snapshot) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Image.asset('assets/images/loading.gif'),
          );
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _builderUserListItem(doc))
              .toList(),
        );
      },
    );
  }


  Widget _builderUserListItem(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  }

}
