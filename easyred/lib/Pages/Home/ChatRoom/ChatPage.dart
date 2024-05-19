
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyred/Pages/Home/ChatRoom/Chat.dart';
import 'package:easyred/Pages/Home/drawerHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        body: _builderUserList());
  }

  Widget _builderUserList() {
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

    if (_auth.currentUser?.uid != data['userUid']) {
      return Column(
        children: [
          SizedBox(height: 12,),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, top: 12, bottom: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(data['userImage']),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chat(
                                receiverUsername: data['username'],
                                receiverUserID: data['userUid']),
                          ),
                        );
                      },
                      child: Text(data['username'], style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: HexColor('AF33E1'),
                      ),)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 12),
            child: Divider(height: 2),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
