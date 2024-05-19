import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyred/Firebase/FirebaseChat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class Chat extends StatefulWidget {
  final String receiverUsername;
  final String receiverUserID;
  const Chat(
      {super.key,
      required this.receiverUsername,
      required this.receiverUserID});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseChat _firebaseChat = FirebaseChat();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _firebaseChat.sendMessage(
          widget.receiverUserID, _messageController.text, context);
      _messageController.clear();
    }
  }

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
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: RichText(
                  text: TextSpan(
                      text: widget.receiverUsername,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: HexColor('AF33E1')))),
            ),
          ],
        )),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageImput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _firebaseChat.getMessages(
          widget.receiverUserID, _auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    var alignment = data['senderID'] == _auth.currentUser!.uid
        ? Alignment.centerRight
        : Alignment.centerLeft;

    var color = data['senderID'] == _auth.currentUser!.uid
        ? HexColor('AF33E1')
        : HexColor('FFD700');

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: color,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 2),
                      blurRadius: 2)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(data['message'], style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.normal
              ),),
            ),
          )

        ],
      ),
    );
  }

  Widget _buildMessageImput() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                hintText: 'Type a message',
                hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
              ),
              maxLines: null,
            ),
          ),
          FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
            onPressed: () {
              sendMessage();
            },
            child: Icon(
              Icons.send,
              color: HexColor('AF33E1'),
            ),
            mini: true,
          )
        ],
      ),
    );
  }
}
