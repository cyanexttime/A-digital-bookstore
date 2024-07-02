import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oms/components/toast.dart';

class resetPassword extends StatefulWidget {
  const resetPassword({Key? key}) : super(key: key);

  @override
  _resetPasswordState createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {

  final TextEditingController _newPasswordController = TextEditingController();

  void _sendNewPassword(BuildContext context) async{
      try{
        String newPassword = _newPasswordController.text;
        await FirebaseAuth.instance.sendPasswordResetEmail(email: newPassword);
        showToast('Password reset email sent');
      }
      catch (e){
        showToast('Error: $e');
      }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: Container(
        color: Color(0xFFF1DCD1),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
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
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          fillColor: Colors.grey.shade100,
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
                                backgroundColor: Color(0xff80669d),
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () {
                                _sendNewPassword(context);
                              },
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('RESET NOW',
                                  style: TextStyle(
                                    color: Colors.white
                                  ),),
                                  Icon(
                                    Icons.refresh,
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
                              Navigator.pushNamed(context, 'login');
                            },
                            child: const Text(
                              'LOGIN',
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
