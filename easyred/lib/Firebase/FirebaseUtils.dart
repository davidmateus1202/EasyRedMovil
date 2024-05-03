import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyred/Firebase/Authentication.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FirebaseUtils with ChangeNotifier {
  final picker = ImagePicker();
  File? userAvatar;
  File get getUserAvatar => userAvatar!;
  String? userAvatarUrl;
  String? get getUserAvatarUrl => userAvatarUrl;

  String? initUserAvatar;
  String? get getinitUserAvatar => initUserAvatar;
  String? initUsername;
  String? get getinitUsername => initUsername;

  Future getImage(BuildContext context) async {
    final pickerImage = await picker.pickImage(source: ImageSource.gallery);
    userAvatar = File(pickerImage!.path);
    print(userAvatar);

  }

  Future<bool> uploadFile(BuildContext context) async {

    final FirebaseStorage _storage = FirebaseStorage.instance;
    var image =
        Provider.of<FirebaseUtils>(context, listen: false).getUserAvatar;

    print(image);

    final String namefile = image.path.split('/').last;

    Reference upload =
        _storage.ref().child('users').child('images').child(namefile);
    final UploadTask uploadTask = upload.putFile(image);
    print(uploadTask);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

    print(snapshot);

    userAvatarUrl = await snapshot.ref.getDownloadURL();
    print(userAvatarUrl);

    return false;
  }

  Future uploadImage(BuildContext context) async {
    UploadTask imageUpload;
    Reference imageReferene = FirebaseStorage.instance.ref().child(
          'userAvatar/${Provider.of<FirebaseUtils>(context, listen: false).getUserAvatar.path}/${DateTime.now()}',
        );
    print(imageReferene);
    imageUpload = imageReferene.putFile(
        Provider.of<FirebaseUtils>(context, listen: false).getUserAvatar);
    print('imagen despues del putfile $imageUpload');
    await imageUpload.whenComplete(() {
      print('imagen cargada');
    });

    imageReferene.getDownloadURL().then((url) {
      Provider.of<FirebaseUtils>(context, listen: false).userAvatarUrl =
          url.toString();
      notifyListeners();
    });
  }

  Future createUser(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<AuthenticationServices>(context, listen: false)
            .getUserUid)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(Provider.of<AuthenticationServices>(context, listen: false)
              .getUserUid)
          .get();

      print('Informacion del usuario');
      initUserAvatar = doc['userImage'];
      initUsername = doc['username'];
      print(initUserAvatar);
      print(initUsername);
      print('fin informacion');
    } catch (e) {
      print('Error obteniendo información del usuario: $e');
    }
  }
}
