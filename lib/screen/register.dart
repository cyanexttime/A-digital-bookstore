import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oms/firebase_auth_implementation/firebase_auth_services.dart';


class myRegister extends StatefulWidget {
  const myRegister({Key? key}) : super(key: key);

  @override
  _myRegisterState createState() => _myRegisterState();
}

class _myRegisterState extends State<myRegister> {
  //
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  
  //ket noi toi dich vu firebae
  FirebaseAuthService _auth = new FirebaseAuthService();

  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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

  //xu ly su kien dang ky
  void _signUp(BuildContext context) async{
      String userName = _usernameController.text;
      String emailName = _emailController.text;
      String phoneName = _phoneController.text;
      String passwordName = _passwordController.text;

      User? user = await _auth.signUpWithEmailAndPassword(emailName, passwordName);
      if(user != null){
        print('Dang ky thanh cong');
        Navigator.pushNamed(context, 'home');
      }else{
        print('Dang ky that bai');
      }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF1DCD1),
        ),
        child: Scaffold(
          appBar: AppBar(
              elevation: null,
              backgroundColor: Colors.transparent,
              leading: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'login');
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                ),
              )
            ),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 215,
                        height: 215,
                        child:Image.asset('assets/logo.png')
                      )
                    ),
                    // Thay thế 'path_to_your_logo.png' bằng đường dẫn thực tế đến logo của bạ
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
                        decoration: InputDecoration(
                          labelText: 'Username',
                          fillColor: Colors.transparent,
                          prefixIcon: Icon(Icons.people_outline),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              )),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          prefixIcon: Icon(Icons.email_outlined),
                          filled: true,
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          prefixIcon: Icon(Icons.phone),
                          filled: true,
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      TextField(
                        controller: _passwordController,
                        obscureText: _isHidden,
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: _toggleVisibility,
                            icon: _isHidden
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                          ),
                          filled: true,
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                maximumSize: const Size(170.0, 90.0),
                                minimumSize: const Size(170.0, 60.0),
                                backgroundColor: Color(0xff80669d),
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () {
                                _signUp(context);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('REGISTER',
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                  ),
                                  Icon(
                                    Icons.content_paste_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              )),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'login');
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'forgot');
                            },
                            child: Text(
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
