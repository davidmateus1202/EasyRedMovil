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
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Post')
          .where('postId', isEqualTo: postid)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        String postID = doc.id;
        return postID;
      } else {
        return false;
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
    var subDocComents = Uuid();
    String commentid = subDocComents.v4();
    String post = await PostId(postId);
 
  }
}
