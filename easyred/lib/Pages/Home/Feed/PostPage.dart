import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyred/Firebase/Authentication.dart';
import 'package:easyred/Firebase/FirebasePost.dart';
import 'package:easyred/Firebase/FirebaseUtils.dart';
import 'package:easyred/Pages/Home/Feed/HomePage.dart';
import 'package:easyred/Utils/ShowDialogs.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Future<void> _userData = Future.value();

  @override
  void initState() {
    super.initState();
    _userData = Provider.of<FirebaseUtils>(context, listen: false)
        .initUserData(context);
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
              RichText(
                  text: TextSpan(
                      text: 'Create',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: HexColor('AF33E1')))),
              RichText(
                  text: TextSpan(
                      text: ' Post',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: HexColor('FFD700')))),
            ],
          )),
        ),
        body: FutureBuilder<void>(
            future: _userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Image.asset(
                  'assets/images/loading.gif',
                  width: 50,
                  height: 50,
                ));
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text('Error en la comunicacion con el servidor',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold)));
              } else {
                return _builPost();
              }
            }));
  }
}

class _builPost extends StatefulWidget {
  const _builPost({super.key});

  @override
  State<_builPost> createState() => __builPostState();
}

class __builPostState extends State<_builPost> {
  TextEditingController _content = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? imagePost;
  final picker = ImagePicker();
  bool _isLogin = false;
  var uuid = Uuid();
  String? postID;

  @override
  void initState() {
    super.initState();
    postID = uuid.v4();
  }

  Future getImage(op) async {
    if (op == 1) {
      final PirckerImage = await picker.pickImage(source: ImageSource.gallery);

      if (PirckerImage != null) {
        setState(() {
          imagePost = File(PirckerImage.path);
        });
      } else {
        print('Select a image');
      }
    } else {
      final PirckerImage = await picker.pickImage(source: ImageSource.camera);

      if (PirckerImage != null) {
        setState(() {
          imagePost = File(PirckerImage.path);
        });
      } else {
        print('Select a image');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12, left: 12),
                            child: Row(
                              children: [
                                _builderAvatar(context),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    '${Provider.of<FirebaseUtils>(context, listen: false).initUsername}',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 100,
                        child: TextFormField(
                          maxLines: 10,
                          controller: _content,
                          decoration: InputDecoration(
                            hintText: 'Why are feeling today?',
                            hintStyle: TextStyle(fontFamily: 'Poppins'),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      imagePost != null
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: FadeInImage(
                                placeholder: AssetImage(
                                    'assets/images/giflodingPost.gif'),
                                image: FileImage(imagePost!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: FadeInImage(
                                placeholder: AssetImage(
                                    'assets/images/giflodingPost.gif'),
                                image: AssetImage('assets/images/default.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 16,
                shadowColor: HexColor('9A0EE2'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(
                        color: Colors.grey[200] ?? Colors.transparent,
                        width: 2)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 15,
                        color: HexColor('9A0EE2'),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 24, left: 24),
                          child: Row(
                            children: [
                              Icon(
                                Icons.photo,
                                color: HexColor('9A0EE2'),
                                size: 35,
                              ),
                              TextButton(
                                  onPressed: () {
                                    getImage(1);
                                  },
                                  child: Text(
                                    'Photo / ',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (imagePost != null) {
                                      setState(() {
                                        _isLogin = true;
                                      });
                                      Provider.of<FirebasePost>(context,
                                              listen: false)
                                          .uoloadImagePost(imagePost)
                                          .whenComplete(() {
                                        Provider.of<FirebasePost>(context,
                                                listen: false)
                                            .createPost(context, {
                                          "postId": postID,
                                          "username":
                                              Provider.of<FirebaseUtils>(
                                                      context,
                                                      listen: false)
                                                  .initUsername,
                                          "userImage":
                                              Provider.of<FirebaseUtils>(
                                                      context,
                                                      listen: false)
                                                  .initUserAvatar,
                                          "userUid": Provider.of<
                                                      AuthenticationServices>(
                                                  context,
                                                  listen: false)
                                              .getUserUid,
                                          "content": _content.text,
                                          "time": DateTime.now(),
                                          "postImageUrl":
                                              Provider.of<FirebasePost>(context,
                                                      listen: false)
                                                  .postImageUrl
                                        }).whenComplete(() {
                                          Navigator.pushReplacement(
                                              context,
                                              PageTransition(
                                                  child: HomePage(),
                                                  type: PageTransitionType
                                                      .rightToLeft));
                                        });
                                      });
                                      setState(() {
                                        _isLogin = false;
                                      });
                                    } else {
                                      ShowDialogs.showAlertDialog(
                                        context,
                                        'Error',
                                        'Select a image',
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => HexColor('AF33E1')),
                                  ),
                                  child: const Text(
                                    'Post',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontSize: 12),
                                  ),
                                ),
                              )
                            ],
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Divider()),
                      Padding(
                          padding: EdgeInsets.only(top: 24, left: 24),
                          child: Row(
                            children: [
                              Icon(
                                Icons.camera,
                                color: HexColor('9A0EE2'),
                                size: 35,
                              ),
                              TextButton(
                                  onPressed: () {
                                    getImage(2);
                                  },
                                  child: Text(
                                    'Camera',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  )),
                            ],
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Divider()),
                      Padding(
                          padding: EdgeInsets.only(top: 24, left: 24),
                          child: Row(
                            children: [
                              Icon(
                                Icons.photo,
                                color: HexColor('9A0EE2'),
                                size: 35,
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Nose',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  )),
                            ],
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Divider()),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        if (_isLogin)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Image.asset(
                'assets/images/loading.gif',
                width: 50,
                height: 50,
              ),
            ),
          )
      ],
    );
  }

  Widget _builderAvatar(context) {
    String? userAvatar =
        Provider.of<FirebaseUtils>(context, listen: false).initUserAvatar;
    if (userAvatar != null) {
      return CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(userAvatar),
      );
    } else {
      return CircleAvatar(
          radius: 25, backgroundImage: AssetImage('assets/images/default.jpg'));
    }
  }
}
