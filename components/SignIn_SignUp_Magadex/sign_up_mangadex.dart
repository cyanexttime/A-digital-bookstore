import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:oms/API/authencation.dart';
import 'package:oms/components/api_variables.dart';
import 'package:url_launcher/url_launcher.dart';


class RegisterFormDialog extends StatefulWidget {
  const RegisterFormDialog({super.key});

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
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Register failed'),
            content: const Text('Please fill in all fields'),
            actions: [
              TextButton(
                onPressed: () {
                  _usernameController.text = '';
                  _passwordController.text = '';
                  _clientIdController.text = '';
                  _secretIdController.text = '';
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
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
      Navigator.of(context).pop();
      Navigator.of(context).pop();  
    } else {
      print('Register failed');
    }
  }

  Widget Decrepsion() {
    return RichText(
      text:TextSpan(
        text: "You can get your Client ID and Secret ID by registering an account on Mangadex website. For more information, please visit",
        style: const TextStyle(color: Colors.black),
        children: [
          const TextSpan(
            text: "\nMangadex registration link: ",
          ),
          TextSpan(
            text: "https://mangadex.org/",
            style: const TextStyle(decoration: TextDecoration.underline,color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                 launchUrl(Uri.parse("https://mangadex.org/"));
              },
          ),
          const TextSpan(
            text: "\nApiclient registration link: ",
          ),
          TextSpan(
            text: "https://mangadex.org/",
            style: const TextStyle(decoration: TextDecoration.underline,color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                 launchUrl(Uri.parse("https://mangadex.org/settings"));
              },
          ),
        ],
      ),
    );
  }


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
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Text(
                'Register',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Decrepsion(),
            const SizedBox(height: 5),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
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
              obscureText: _isHidden,
            ),
            TextField(
              controller: _clientIdController,
              decoration: const InputDecoration(labelText: 'Client ID'),
            ),
            TextField(
              controller: _secretIdController,
              decoration: const InputDecoration(labelText: 'Secret ID'),
            ),
            const SizedBox(height: 20),
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
                    // Handle Register action
                    String username = _usernameController.text;
                    String password = _passwordController.text;
                    String clientId = _clientIdController.text;
                    String secretId = _secretIdController.text;
                    // Implement registration logic here
                    await IsEmptyAccount(username, password, clientId, secretId);
                  },
                  child: const Text('Register') ,
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
