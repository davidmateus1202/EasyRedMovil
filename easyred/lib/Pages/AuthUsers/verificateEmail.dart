import 'package:easyred/Pages/AuthUsers/LoginPage.dart';
import 'package:easyred/Pages/Home/Feed/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class VerificateEmailPage extends StatelessWidget {
  const VerificateEmailPage({super.key});

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
        body: FirebaseAuth.instance.currentUser!.emailVerified
            ? const HomePage()
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
