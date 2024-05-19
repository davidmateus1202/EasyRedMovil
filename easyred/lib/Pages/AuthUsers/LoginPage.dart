import 'package:easyred/Pages/AuthUsers/RegisterPage.dart';
import 'package:easyred/Pages/AuthUsers/VerificateEmailPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:page_transition/page_transition.dart';

import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:easyred/Firebase/Authentication.dart';
import 'package:provider/provider.dart';
import 'package:easyred/Pages/Home/Feed/HomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLogin = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _formKeypassword = GlobalKey<FormFieldState>();
  final _formKeyemail = GlobalKey<FormFieldState>();

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
              Text('Login',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: HexColor('8E32BE'))),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 36),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Don\'t have an account?',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: HexColor('8E32BE'))),
                    TextSpan(
                        text: ' Register',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: HexColor('FFD700')),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: RegisterPage(),
                                    type: PageTransitionType.leftToRight));
                          }),
                  ]),
                ),
              ),
              FormTextEmail(),
              SizedBox(height: 24),
              FormTextPassword(),
              SizedBox(height: 80),
              ButtonLogin(),
              SizedBox(height: 12),
              IconButtonGmail(),
            ],
          ),
          )
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

  Widget FormTextEmail() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        key: _formKeyemail,
        controller: _emailController,
        onChanged: (value) {
          _formKeyemail.currentState?.validate();
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email, color: HexColor('8E32BE')),
          labelText: 'Email',
          labelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: HexColor('8E32BE')),
          hintText: 'Ingrese su email',
          hintStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: HexColor('8E32BE')),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(36),
              borderSide: BorderSide(color: HexColor('8E32BE'))),
        ),
        validator: (value) {
          // ignore: unnecessary_null_comparison
          if (value!.isEmpty || value.contains('@') == false || value == null) {
            return 'Email invalido';
          }
          return null;
        },
      ),
    );
  }

  Widget FormTextPassword() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,

      child: TextFormField(
        obscureText: true,
        key: _formKeypassword,
        controller: _passwordController,
        onChanged: (value) {
          _formKeypassword.currentState?.validate();
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: HexColor('8E32BE')),
          labelText: 'Contraseña',
          labelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: HexColor('8E32BE')),
          hintText: 'Ingrese su constraseña',
          hintStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: HexColor('8E32BE')),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(36),
              borderSide: BorderSide(color: HexColor('8E32BE'))),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Contraseña invalida';
          }
          return null;
        },
      ),
    );
  }

  Widget ButtonLogin() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: ElevatedButton(
        onPressed: () async {
          String email = _emailController.text.trim();
          String password = _passwordController.text.trim();

          if (_formKeyemail.currentState!.validate() &&
              _formKeypassword.currentState!.validate()) {
            setState(() {
              _isLogin = true;
            });
            await sigIn();
          }

          setState(() {
            _isLogin = false;
          });
        },
        child: Text('L O G I N',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: HexColor('8E32BE'))),
      ),
    );
  }

  Widget IconButtonGmail() {
    return IconButton(
        icon: Icon(
          Icons.email,
          color: HexColor('8E32BE'),
          size: 40,
        ),
        onPressed: () async {
          final authService =
              Provider.of<AuthenticationServices>(context, listen: false);

          var userGoogle = await authService.sigInWithGoogle();

          if (userGoogle != null) {
            print(userGoogle);
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: HomePage(), type: PageTransitionType.leftToRight));
          }
        });
  }

  Future sigIn() async {
    final authService =
        Provider.of<AuthenticationServices>(context, listen: false);

    try {
      await authService.sigIn(
          _emailController.text, _passwordController.text, context);
      if (Provider.of<AuthenticationServices>(context, listen: false)
              .getUserUid !=
          null) {
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: HomePage(), type: PageTransitionType.leftToRight));
        } else {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: VerificateEmailPage(),
                  type: PageTransitionType.leftToRight));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usuario o contraseña incorrecta'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
