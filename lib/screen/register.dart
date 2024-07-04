// ignore_for_file: library_private_types_in_public_api, camel_case_types, avoid_print, use_build_context_synchronously, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oms/firebase_auth_implementation/firebase_auth_services.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  _myRegisterState createState() => _myRegisterState();
}

class _myRegisterState extends State<MyRegister> {
  // Initialize controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Connect to Firebase service
  final FirebaseAuthService _auth = FirebaseAuthService();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Password Field obscureText Handler
  bool _isHidden = true;
  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  // Handle sign-up event
  void _signUp(BuildContext context) async {
    String userName = _usernameController.text;
    String emailName = _emailController.text;
    String phoneName = _phoneController.text;
    String passwordName = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(emailName, passwordName);
    if (user != null) {
        showSnackbar(context, 'Sign up successful',Colors.purple);
        print('Sign up successful');
        Navigator.pushNamed(context, 'home');
      }
    else {
      showSnackbar(context, 'Sign up failed',Colors.red);
      print('Sign up failed');
    }

  }
  void showSnackbar(BuildContext context, String message,Color color) {
  final snackBar = SnackBar(
    content: Text(message,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor:color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset('assets/logo.png'),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28,
                    left: 35,
                    right: 35,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.black), // Set text color
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: const TextStyle(color: Colors.black), // Set label text color
                          fillColor: Colors.grey.shade100,
                          prefixIcon: const Icon(Icons.people_outline, color: Colors.black),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.black), // Set text color
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          prefixIcon: const Icon(Icons.email_outlined, color: Colors.black),
                          filled: true,
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.black), // Set label text color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      TextField(
                        controller: _phoneController,
                        style: const TextStyle(color: Colors.black), // Set text color
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          prefixIcon: const Icon(Icons.phone, color: Colors.black),
                          filled: true,
                          labelText: 'Phone',
                          labelStyle: const TextStyle(color: Colors.black), // Set label text color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      TextField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.black), // Set text color
                        obscureText: _isHidden,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          prefixIcon: const Icon(Icons.lock, color: Colors.black),
                          suffixIcon: IconButton(
                            onPressed: _toggleVisibility,
                            icon: _isHidden
                                ? const Icon(Icons.visibility, color: Colors.black)
                                : const Icon(Icons.visibility_off, color: Colors.black),
                          ),
                          filled: true,
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.black), // Set label text color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
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
                              _signUp(context);
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'REGISTER',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  Icons.content_paste_rounded,
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
                              Navigator.pushNamed(context, 'login');
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'forgot');
                            },
                            child: const Text(
                              'Forgot password?',
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
