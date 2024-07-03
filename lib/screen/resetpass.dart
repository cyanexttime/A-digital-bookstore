// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  _resetPasswordState createState() => _resetPasswordState();
}

class _resetPasswordState extends State<ResetPassword> {

  final TextEditingController _newPasswordController = TextEditingController();

  void _sendNewPassword(BuildContext context) async {
    try {
      String newPassword = _newPasswordController.text;
      await FirebaseAuth.instance.sendPasswordResetEmail(email: newPassword);
      showSnackbar(context,'Password reset email sent');
    } catch (e) {
      showToast('Error: $e', Colors.red);
    }
  }

  void showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.purple,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
  void showToast(String message, Color bgColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xFFF1DCD1),
        child: Scaffold(
          appBar: AppBar(
            elevation: null,
            backgroundColor: Colors.transparent,
            leading: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'login');
              },
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: Image.asset('assets/main_logo.png'),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                    left: 35,
                    right: 35,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _newPasswordController,
                        style: const TextStyle(color: Colors.black), // Set text color
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.black), // Set label text color
                          prefixIcon: const Icon(Icons.email_outlined, color: Colors.black),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              maximumSize: const Size(170.0, 90.0),
                              minimumSize: const Size(170.0, 60.0),
                              backgroundColor: const Color(0xff80669d),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              _sendNewPassword(context);
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'RESET NOW',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'register');
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'login');
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
