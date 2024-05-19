import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyred/Firebase/Authentication.dart';
import 'package:easyred/Firebase/FirebaseUtils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FirebasePost with ChangeNotifier {
  String? postImageUrl;
  String? userLikeUid;

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
    return FirebaseFirestore.instance.collection('Post').add(data);
  }

  Future PostId(String postid) async {
    String postID;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Post')
          .where('postId', isEqualTo: postid)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        postID = doc.id;
        return postID;
      } else {
        return postID = '';
      }
    } catch (e) {
      print(e);
    }
  }

  Future ObtenerIdPostDelete(String postid) async {
    try {
      String post = await PostId(postid);
      FirebaseFirestore.instance.collection('Post').doc(post).delete();
    } catch (e) {
      print(e);
    }
  }

  Future Comment(BuildContext context, String postId, String comment) async {
    String post = await PostId(postId);
    var userUid =
        await Provider.of<AuthenticationServices>(context, listen: false)
            .getUserUid;
    DateTime time = DateTime.now();
    var userImage =
        await Provider.of<FirebaseUtils>(context, listen: false).initUserAvatar;
    var username =
        await Provider.of<FirebaseUtils>(context, listen: false).initUsername;

    print(userUid);
    print(time);
    print(userImage);
    print(username);

    Map<String, dynamic> data = {
      'comment': comment,
      'userUid': userUid,
      'time': time,
      'userImage': userImage,
      'username': username,
    };

    try {
      FirebaseFirestore.instance
          .collection('Post')
          .doc(post)
          .collection('Comments')
          .doc()
          .set(data);
    } catch (e) {
      print(e);
    }
  }

  Future getComments(context, postId) async {
    String post = await PostId(postId);
    if (post != '') {
      try {
        print('entro');
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Post')
            .doc(post)
            .collection('Comments')
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          print('entro2');
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print(e);
      }
    } else {
      return false;
    }
  }
}
