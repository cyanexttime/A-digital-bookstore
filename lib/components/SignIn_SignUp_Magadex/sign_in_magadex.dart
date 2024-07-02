import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oms/API/authencation.dart';
import 'package:oms/components/api_variables.dart';

class LoginFormDialog extends StatefulWidget {
  @override
  const LoginFormDialog({super.key});
  @override
  State<LoginFormDialog> createState() => _LoginFormDialogState();
}

class _LoginFormDialogState extends State<LoginFormDialog> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> CheckAccountMangadex(String user, String password) async {
    if (user.isEmpty || password.isEmpty) {
      print('Please fill all fields');
      return false;
    }
    QuerySnapshot querySnapshot =
        await firestore.collection('mangadex_account').get();
    for (var doc in querySnapshot.docs) {
      if (doc.id == user && doc['password'] == password) {
        String clientId = doc['clientId'];
        String secretID = doc['secretId'];
        String? response =
            await getResfreshingToken(user, password, clientId, secretID);
        if (response != null) {
          apiVariables.clientId = clientId;
          apiVariables.secretId = secretID;
          apiVariables.refreshToken = response;
          apiVariables.username = user;
          apiVariables.password = password;
          apiVariables.isLogin = true;
          return true;
                }
      } else {
        print("fail dang ki");
        //in gi do
      }
    }
    return false;
  }

  // dung de xu ly tinh nang
  //  Future<bool> CheckAccountMangadex(String user,String password) async {
  //       user = 'Thanh8806';
  //       password = 'thanh080804@gmail.com';
  //       String clientId = 'personal-client-b899bbf6-0f42-4136-96a2-74fbeb8d9176-dd343205';
  //       String secretID= 'R4Lopt85Qgv7keEEGLMdK7dRCCW5kCCH';
  //       String? response = await getResfreshingToken(user, password, clientId, secretID);
  //       if(response != null){
  //         apiVariables.clientId = clientId;
  //         apiVariables.secretId = secretID;
  //         apiVariables.refreshToken = response;
  //         apiVariables.username = user;
  //         apiVariables.password = password;
  //         apiVariables.isLogin = true;
  //         if(apiVariables.refreshToken != null){
  //           return true;
  //         }
  //         else{
  //           return false;
  //         }
  //         }
  //       else{
  //         return false;
  //       }
  // }

  bool _isHidden = true;
  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: const Text(
                  'Sign In to Mangadex Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please enter your username and password of your Mangadex account to login.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                obscureText: _isHidden,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: _toggleVisibility,
                    icon: _isHidden
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle register action here
                  Navigator.pushNamed(context, 'signUpMangadex');
                },
                child: const Text(
                  'Register here',
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle Cancel action
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Handle Login action
                      String username = _usernameController.text;
                      String password = _passwordController.text;
                      // Implement login logic here
                      bool check =
                          await CheckAccountMangadex(username, password);
                      if (check == true) {
                        Navigator.pop(context, true);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Login failed'),
                              content: const Text(
                                  'Please check your username and password again'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    _usernameController.text = '';
                                    _passwordController.text = '';
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
