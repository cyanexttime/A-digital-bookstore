import 'package:firebase_auth/firebase_auth.dart';
import 'package:oms/components/toast.dart';

class FirebaseAuthService{
    FirebaseAuth _auth = FirebaseAuth.instance;
 
    Future<User?> signUpWithEmailAndPassword(String email, String password) async {
        try {
            UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                email: email,
                password: password
            );
            return userCredential.user;
        } on FirebaseAuthException catch (e) {
            if(e.code == 'email-already-in-use'){
                showToast('The account already exists for that email.');
            }
            else
            {
              showToast('Error: ${e.code}');
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
      } on FirebaseAuthException catch (e) {
        print(e.code);
          if(e.code == 'invalid-credential'){
              showToast('Email or password is incorrect.');
          }
          else
          {
            showToast('Error: ${e.code}');
          }
          return null;
      }
    }
}