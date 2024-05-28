import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterFormDialog extends StatefulWidget {
  @override
  _RegisterFormDialogState createState() => _RegisterFormDialogState();
}

class _RegisterFormDialogState extends State<RegisterFormDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _clientIdController = TextEditingController();
  final TextEditingController _secretIdController = TextEditingController();

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
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
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
              obscureText: true,
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
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    String clientId = _clientIdController.text;
                    String secretId = _secretIdController.text;
                    // Implement registration logic here

                    Navigator.of(context).pop();
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
