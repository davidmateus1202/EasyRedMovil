import 'dart:io';

import 'package:easyred/Firebase/Authentication.dart';
import 'package:easyred/Firebase/FirebaseUtils.dart';
import 'package:easyred/Pages/AuthUsers/LoginPage.dart';
import 'package:easyred/Pages/Home/Feed/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerificateEmailPage extends StatefulWidget {
  const VerificateEmailPage({super.key});

  @override
  State<VerificateEmailPage> createState() => _VerificateEmailPageState();
}

class _VerificateEmailPageState extends State<VerificateEmailPage> {
  final TextEditingController _nameController = TextEditingController();
  File? userAvatar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                await FirebaseAuth.instance.signOut().whenComplete(() {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                });
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(userAvatar ?? File('')),
              ),
              TextFormField(
                controller: _nameController,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await Provider.of<FirebaseUtils>(context, listen: false)
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
                  child: Text('Guardar')),
              ElevatedButton(
                  onPressed: () {
                    Provider.of<FirebaseUtils>(context, listen: false)
                        .createUser(context, {
                      'userUid':Provider.of<AuthenticationServices>(context, listen: false).getUserUid,
                      'username': _nameController.text,
                      'userImage':
                          Provider.of<FirebaseUtils>(context, listen: false)
                              .getUserAvatarUrl
                    }).whenComplete(() {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    });
                  },
                  child: Text('crear usuario')),
              const Text('Verifica tu correo'),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.currentUser!
                      .sendEmailVerification();
                },
                child: const Text('Reenviar correo'),
              ),
            ],
          ),
        ));
  }
}
