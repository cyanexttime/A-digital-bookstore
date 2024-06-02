import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:oms/API/authencation.dart';
import 'package:oms/components/api_variables.dart';
import 'package:url_launcher/url_launcher.dart';


class RegisterFormDialog extends StatefulWidget {
  @override
  _RegisterFormDialogState createState() => _RegisterFormDialogState();
}

class _RegisterFormDialogState extends State<RegisterFormDialog> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _clientIdController = TextEditingController();
  final TextEditingController _secretIdController = TextEditingController();
  
  Future<void> IsEmptyAccount(String username, String password, String clientId, String secretId) async {
    if (username.isEmpty || password.isEmpty || clientId.isEmpty || secretId.isEmpty) {
      print('Please fill all fields');
      return;
    } 
    String? response = await getResfreshingToken(username, password, clientId, secretId);
    if(response != null){
      ApiVariables apiVariables = ApiVariables(
        username: username,
        password: password,
        clientId: clientId,
        secretId: secretId,
        isLogin: true,
        refreshToken: response, 
      );
      FetchDataToFireStore(apiVariables: apiVariables);
    } else {
      print('Register failed');
    }
  }

  Widget Decrepsion() {
    return RichText(
      text: TextSpan(
        text: "https://mangadex.org/",
        style: 
          TextStyle(decoration: TextDecoration.underline,color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                 launchUrl(Uri.parse("https://mangadex.org/"));
              },
          ),
      );
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
                'Register',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            Decrepsion(),
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
            TextField(
              controller: _clientIdController,
              decoration: InputDecoration(labelText: 'Client ID'),
            ),
            TextField(
              controller: _secretIdController,
              decoration: InputDecoration(labelText: 'Secret ID'),
            ),
            SizedBox(height: 20),
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
                    // Handle Register action
                    String username = _usernameController.text;
                    String password = _passwordController.text;
                    String clientId = _clientIdController.text;
                    String secretId = _secretIdController.text;
                    // Implement registration logic here
                    IsEmptyAccount(username, password, clientId, secretId);
                    Navigator.of(context).pop();
                  },
                  child: Text('Register') ,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void FetchDataToFireStore({required ApiVariables apiVariables}) {
  CollectionReference account = FirebaseFirestore.instance.collection('mangadex_account');
  account 
  .doc(apiVariables.username)
  .set(
    {
      'password': apiVariables.password,
      'clientId': apiVariables.clientId,
      'secretId': apiVariables.secretId,
    })
  .then((value) => print('Account added'))
  .catchError((error) => print('Failed to add account: $error'));
}
