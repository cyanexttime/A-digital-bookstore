import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService{
    final FirebaseAuth _auth = FirebaseAuth.instance;
 
    Future<User?> signUpWithEmailAndPassword(String email, String password) async {
        try {
            UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                email: email,
                password: password
            );
            return userCredential.user;
        } catch (e) {
            if (kDebugMode) {
              print(e);
            }
            return null;
        }
    }

    Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
              email: email,
              password: password
          );
          return userCredential.user;
      } catch (e) {
          if (kDebugMode) {
            print(e);
          }
          return null;
      }
    }
}