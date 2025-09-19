import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class RegistrationService extends ChangeNotifier{

  void registerUser(String email, String password){
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
    }
    on FirebaseAuthException catch (e){
      print(e.code);
    }
  }

  void loginUser(String email, String password){
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
    }
    on FirebaseAuthException catch (e){
      print(e.code);
    }
  }

}