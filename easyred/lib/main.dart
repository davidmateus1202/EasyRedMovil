import 'package:easyred/Firebase/FirebaseChat.dart';
import 'package:easyred/Firebase/FirebasePost.dart';
import 'package:easyred/Firebase/FirebaseUtils.dart';
import 'package:easyred/Pages/AuthUsers/LoginPage.dart';
import 'package:easyred/Pages/AuthUsers/VerificateEmailPage.dart';
import 'package:easyred/Pages/AuthUsers/authPage.dart';
import 'package:easyred/Pages/Home/Feed/HomePage.dart';
import 'package:easyred/Pages/SplashScreen.dart';
import 'package:easyred/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easyred/Firebase/Authentication.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const EasyRed());
}

class EasyRed extends StatefulWidget {
  const EasyRed({super.key});

  @override
  State<EasyRed> createState() => _EasyRedState();
}

class _EasyRedState extends State<EasyRed> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebasePost()),
        ChangeNotifierProvider(create: (_) => FirebaseUtils()),
        ChangeNotifierProvider(create: (_) => AuthenticationServices()),
        ChangeNotifierProvider(create: (_) => FirebaseChat())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {
          '/AuthPage': (context) => AuthPage(),
          '/loginPage': (context) => LoginPage(),
          '/Home': (context) => HomePage(),
        },
      ),
    );
  }
}


