import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oms/API/authencation.dart';
import 'package:oms/components/api_variables.dart';
import 'package:oms/config/app_config.dart';

class LoginFormDialog extends StatefulWidget {
  @override
  _LoginFormDialogState createState() => _LoginFormDialogState();
}

class _LoginFormDialogState extends State<LoginFormDialog> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> CheckAccountMangadex(String user,String password) async {
    if (user.isEmpty || password.isEmpty) {
      print('Please fill all fields');
      return;
    } 
    QuerySnapshot querySnapshot = await firestore.collection('mangadex_account').get();
    for (var doc in querySnapshot.docs) {
      if(doc.id == user && doc['password'] == password)
        {
          String clientId = doc['clientId'];
          String secretID= doc['secretId'];
          String? response = await getResfreshingToken(user, password, clientId, secretID);
          if(response != null){
            ApiVariables apiVariables = ApiVariables(
              username: user,
              password: password,
              clientId: clientId,
              secretId: secretID,
              refreshToken: response,
            );
           }

        }
      else {
        print('Login failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Text(
                'Sign In to Mangadex Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Handle register action here
                print("Register here clicked");
              },
              child: Text(
                'Register here',
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle Cancel action
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle Login action
                    String username= _usernameController.text;
                    String password = _passwordController.text;
                    // Implement login logic here
                    CheckAccountMangadex(username, password);
                    Navigator.of(context).pop();
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}