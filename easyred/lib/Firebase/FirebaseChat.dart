import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyred/Firebase/FirebaseUtils.dart';
import 'package:easyred/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseChat extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendMessage(
      String reveicerUid, String message, BuildContext context) async {
    final String currentUserUid = _auth.currentUser!.uid;
    final String currentUser =
        Provider.of<FirebaseUtils>(context, listen: false)
            .initUsername
            .toString();
    final Timestamp time = Timestamp.now();

    Message messageData = Message(
      senderID: currentUserUid,
      senderName: currentUser,
      receiverID: reveicerUid,
      message: message,
      time: time,
    );

    List<String> ids = [currentUserUid, reveicerUid];
    ids.sort();
    String chatRoomId = ids.join('_');

    await FirebaseFirestore.instance
        .collection('Chat_rooms')
        .doc(chatRoomId)
        .collection('Messages')
        .add(messageData.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userid, String otherUserId) {
    List<String> ids = [userid, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return FirebaseFirestore.instance
        .collection('Chat_rooms')
        .doc(chatRoomId)
        .collection('Messages')
        .orderBy('time', descending: false)
        .snapshots();
  }
}
