import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationServices with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String? userUid;
  String? get getUserUid => userUid;

  Future sigIn(String email, String password, context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User user = userCredential.user!;

      // uid indicador unico para cada usuario
      userUid = user.uid;
      notifyListeners();
    } on FirebaseAuthMultiFactorException catch (e) {
      throw Exception(e.code);
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future createAccount(String email, String password, context) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user!;

      // uid indicador unico para cada usuario
      userUid = user.uid;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future sigInWithGoogle() async {
    try {
      // Iniciar sesion con google
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(authCredential);

      final User user = userCredential.user!;
      print(user.uid);
      assert(user.uid != null);
      userUid = user.uid;
      notifyListeners();
      return userUid;
    } catch (e) {
      print(e);
    }

    Future signOutFromGoogle() async {
      try {
        await googleSignIn.signOut();
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    }
  }
}
