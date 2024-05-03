import 'dart:io';
import 'package:easyred/Firebase/Authentication.dart';
import 'package:easyred/Firebase/FirebaseUtils.dart';
import 'package:easyred/Pages/AuthUsers/VerificateEmailPage.dart';
import 'package:easyred/Pages/Home/Feed/HomePage.dart';
import 'package:easyred/Utils/ShowDialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _VerificateEmailPageState();
}

class _VerificateEmailPageState extends State<CreateAccount> {
  bool _isLogin = false;
  final _formKeyemail = GlobalKey<FormFieldState>();
  final TextEditingController _nameController = TextEditingController();
  var currentState = FirebaseAuth.instance.currentUser;
  File? userAvatar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/1.png'), fit: BoxFit.cover)),
        ),
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'Create your',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: HexColor('8E32BE'))),
                  TextSpan(
                      text: ' Profile',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: HexColor('FFD700')))
                ])),
                const SizedBox(
                  height: 20,
                ),
                _PhotoProfile(),
                const SizedBox(
                  height: 20,
                ),
                ContainerButtonsImage(),
                const SizedBox(
                  height: 20,
                ),
                FormTextName(),
                const SizedBox(
                  height: 20,
                ),
                ContainerButtonCreate(),
              ],
            ),
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
    ));
  }

  Widget _PhotoProfile() {
    return CircleAvatar(
      radius: 50,
      backgroundImage:
          FileImage(userAvatar ?? File('assets/images/default.jpg')),
    );
  }

  Widget ContainerButtonsImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.camera_alt,
              color: Colors.grey[300],
            )),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: IconButton(
              onPressed: () {
                Provider.of<FirebaseUtils>(context, listen: false)
                    .getImage(context)
                    .whenComplete(() {
                  Provider.of<FirebaseUtils>(context, listen: false)
                      .uploadFile(context);
                  setState(() {
                    userAvatar =
                        Provider.of<FirebaseUtils>(context, listen: false)
                            .getUserAvatar;
                  });
                });
              },
              icon: Icon(
                Icons.photo,
                color: Colors.grey[300],
              )),
        ),
      ],
    );
  }

  Widget FormTextName() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        key: _formKeyemail,
        controller: _nameController,
        onChanged: (value) {
          _formKeyemail.currentState?.validate();
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Name is required';
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email, color: HexColor('8E32BE')),
          label: Text('Name'),
          labelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              color: HexColor('8E32BE'),
              fontWeight: FontWeight.normal),
          hintText: 'Name',
          hintStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              color: HexColor('8E32BE'),
              fontWeight: FontWeight.normal),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(36)),
        ),
      ),
    );
  }

  Widget ContainerButtonCreate() {
    return ElevatedButton(
        onPressed: () async {
          setState(() {
            _isLogin = true;
          });
          await Future.delayed(Duration(seconds: 3));
          var UserProfileUrl =
              await Provider.of<FirebaseUtils>(context, listen: false)
                  .getUserAvatarUrl;

          if (_formKeyemail.currentState!.validate() &&
              UserProfileUrl != null) {
            CreateUser();
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: VerificateEmailPage(),
                    type: PageTransitionType.rightToLeftWithFade));
          } else {
            ShowDialogs.showAlertDialog(
                context, 'Error', 'Please fill all the fields');
          }
          setState(() {
            _isLogin = false;
          });
        },
        child: Text('Create Profile'));
  }

  void CreateUser() {
    Provider.of<FirebaseUtils>(context, listen: false).createUser(context, {
      'userUid': Provider.of<AuthenticationServices>(context, listen: false)
          .getUserUid,
      'username': _nameController.text.trim(),
      'userImage':
          Provider.of<FirebaseUtils>(context, listen: false).getUserAvatarUrl,
    }).whenComplete(() {
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: HomePage(), type: PageTransitionType.rightToLeftWithFade));
    });
  }
}
