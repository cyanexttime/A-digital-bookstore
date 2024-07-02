
import 'dart:convert';



import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:oms/screen/resetpass.dart';


Map<String,dynamic> data = {};
Future<String?> getResfreshingToken(String username, String password, String clientId, String secretId
) async {
    
  Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  Map<String, String> creds = {
    "grant_type": "password",
    "username": username,
    "password": password,
    "client_id": clientId,
    "client_secret": secretId,
  };
  final response = await http.post(
    Uri.parse("https://auth.mangadex.org/realms/mangadex/protocol/openid-connect/token"),
    headers: headers,
    body: creds,
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> rJson = json.decode(response.body);
    final String accessToken = rJson["access_token"];
    final String refreshToken = rJson["refresh_token"];
    
    print("Refresh Token: $refreshToken");
    return refreshToken;
  } else {
    print("Failed to get tokens: ${response.statusCode}");
    return null;
  }
}
  // Add a return statement h


