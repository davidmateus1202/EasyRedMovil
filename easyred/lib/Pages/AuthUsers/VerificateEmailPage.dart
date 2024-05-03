import 'package:easyred/Pages/AuthUsers/LoginPage.dart';
import 'package:easyred/Pages/Home/Feed/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class VerificateEmailPage extends StatefulWidget {
  const VerificateEmailPage({super.key});

  @override
  State<VerificateEmailPage> createState() => _VerificateEmailPageState();
}

class _VerificateEmailPageState extends State<VerificateEmailPage> {
  bool _isLogin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        FirebaseAuth.instance.currentUser!.emailVerified
            ? HomePage()
            : Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/1.png'),
                        fit: BoxFit.cover)),
              ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'Verificate your',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: HexColor('8E32BE'))),
                TextSpan(
                    text: ' Account',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: HexColor('FFD700'))),

                
              ])),
              Image.asset('assets/images/email.gif', fit: BoxFit.fill),
              SizedBox(height: 24),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    
                    text: 'As a last step, we need to verify your identity. Please click on the following link to validate your identity with your email.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: HexColor('8E32BE')
                    )
                  )
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(onPressed: () async {
                setState(() {
                  _isLogin = true;
                });
                await FirebaseAuth.instance.currentUser!.sendEmailVerification();
                Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: LoginPage()));
                setState(() {
                  _isLogin = false;
                });

              }, child: Text('Send Email', style: TextStyle(fontFamily: 'Poppins', color: HexColor('8E32BE')),)),
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
    ));
  }
}
