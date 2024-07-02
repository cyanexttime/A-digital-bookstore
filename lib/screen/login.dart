import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase_auth_implementation/firebase_auth_services.dart';



class MyLogin extends StatefulWidget {
  const MyLogin({super.key});
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
//khoi tao
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  //ket noi toi dich vu firebae
  final FirebaseAuthService _auth = FirebaseAuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //Password Field obscureText  Handler
  bool _isHidden = true;
  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

   void _signIn(BuildContext context) async{
      String emailName = _emailController.text;
      String passwordName = _passwordController.text;

      User? user = await _auth.signInWithEmailAndPassword(emailName, passwordName);
      if(user != null){
        print('Dang nhap thanh cong');
        Navigator.pushNamed(context, 'home');
      }else{
        print('Dang nhap that bai');
      }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF1DCD1),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Center
                    (
                      child:SizedBox(
                        width: 250,
                        height: 250,
                        child:Image.asset('assets/logo.png')
                      )
                    ),
                    // Thay thế 'path_to_your_logo.png' bằng đường dẫn thực tế đến logo của bạ
                  ],
                ),

              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                    left: 40,
                    right: 40,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the password';
                          } else if (value.length <= 6) {
                            return 'Password must be greater than 6 digits';
                          }
                          return null;
                        },
                        obscureText: _isHidden,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          fillColor: Colors.grey.shade100,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: _toggleVisibility,
                            icon: _isHidden
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                          ),
                          filled: true,
                          // hintText: 'Password',
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
                              onPressed: (){
                                _signIn(context);
                              },
                              child: const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('LOG IN',
                                  style:TextStyle(
                                    color: Colors.white,
                                  ) 
                                  ),
                                  Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                ],
                              )),
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
