import 'dart:io';
import 'dart:math';
import 'package:easyred/Firebase/Authentication.dart';
import 'package:easyred/Firebase/FirebaseUtils.dart';
import 'package:easyred/Pages/AuthUsers/LoginPage.dart';
import 'package:easyred/Pages/AuthUsers/CreateAccount.dart';
import 'package:easyred/Pages/Home/Feed/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLogin = false;
  final _formKeyemail = GlobalKey<FormFieldState>();
  final _formKeypassword = GlobalKey<FormFieldState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/1.png',
                    ),
                    fit: BoxFit.cover)),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create new Account',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: HexColor('8E32BE')),
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'Alreeady Registered?',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: HexColor('8E32BE'),
                          fontWeight: FontWeight.normal)),
                  TextSpan(
                      text: 'Login',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: HexColor('FFD700'),
                          fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: LoginPage(),
                                  type: PageTransitionType.leftToRight));
                        })
                ])),
                const SizedBox(height: 36),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    key: _formKeyemail,
                    controller: _emailController,
                    onChanged: (value) {
                      _formKeyemail.currentState?.validate();
                    },
                    validator: (value) {
                      if (value == null || value.contains('@') == false) {
                        return 'Email invalido';
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: HexColor('8E32BE')),
                      label: Text('Email'),
                      labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: HexColor('8E32BE'),
                          fontWeight: FontWeight.normal),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: HexColor('8E32BE'),
                          fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(36)),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    obscureText: true,
                    key: _formKeypassword,
                    onChanged: (value) {
                      _formKeypassword.currentState?.validate();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password invalido';
                      }
                    },
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: HexColor('8E32BE')),
                      label: Text('Password'),
                      labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: HexColor('8E32BE'),
                          fontWeight: FontWeight.normal),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: HexColor('8E32BE'),
                          fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(36)),
                    ),
                  ),
                ),
                SizedBox(height: 72),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = true;
                      });
                      if (_formKeyemail.currentState!.validate() &&
                          _formKeypassword.currentState!.validate()) {
                        Provider.of<AuthenticationServices>(context,
                                listen: false)
                            .createAccount(_emailController.text.trim(),
                                _passwordController.text.trim(), context);

                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: CreateAccount(),
                                type: PageTransitionType.leftToRight));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${e.toString()}'),
                          ),
                        );
                      }
                      setState(() {
                        _isLogin = false;
                      });
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: HexColor('8E32BE'),
                          fontWeight: FontWeight.normal),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36)))),
                  ),
                ),
              ],
            ),
          ),
          if (_isLogin)
            Container(
              child: Center(
                child: Image.asset(
                  'assets/images/loading.gif',
                  width: 50,
                  height: 50,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class RegisterPhoto with ChangeNotifier {
  Future showModalButtonProfile(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                Container(
                  height: 10,
                  width: MediaQuery.of(context).size.width / 1.8,
                  color: HexColor('8E32BE'),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 36, bottom: 24),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor:
                              const Color.fromARGB(45, 158, 158, 158),
                          backgroundImage: FileImage(
                              Provider.of<FirebaseUtils>(context, listen: false)
                                      .userAvatar ??
                                  File('assets/images/1.png')),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
