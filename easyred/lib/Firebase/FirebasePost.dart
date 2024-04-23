import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyred/Firebase/Authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FirebasePost with ChangeNotifier {
  String? postImageUrl;

  Future<bool> uoloadImagePost(imagePost) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    final String nameFiled = imagePost.path.split('/').last;

    Reference upload = _storage.ref().child('Post').child(nameFiled);
    final UploadTask uploadTask = upload.putFile(imagePost);
    print(uploadTask);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
    postImageUrl = await snapshot.ref.getDownloadURL();
    print(postImageUrl);
    return false;
  }

  Future createPost(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('Post')
        .add(data);
  }

  Future initPostData(BuildContext context) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Post')
          .doc(Provider.of<AuthenticationServices>(context, listen: false)
              .getUserUid)
          .get();
      String postImageUrl = doc['postImageUrl'];
      String postDescription = doc['content'];
      Timestamp postDate = doc['time'];
      String user = doc['userUid'];

      print('informacion del ususario a realizar el post');

      print(postImageUrl);
      print(postDescription);
      print(postDate);
      print(user);
    } catch (e) {
      print(e.toString());
    }
  }
}
