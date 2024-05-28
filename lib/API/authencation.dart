
import 'dart:convert';



import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:http/http.dart';


Map<String,dynamic> data = {};
Future<String?> GetResfreshingToken() async {
  final String username = "<your_username>";
  final String password = "<your_password>";
  final String clientId = "<your_client_id>";
  final String clientSecret = "<your_client_secret>";
    
  Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  Map<String, String> creds = {
    "grant_type": "password",
    "username": "Thanh8806",
    "password": "thanh080804@gmail.com",
    "client_id": "personal-client-b899bbf6-0f42-4136-96a2-74fbeb8d9176-dd343205",
    "client_secret": "R4Lopt85Qgv7keEEGLMdK7dRCCW5kCCH",
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
    
    print("Access Token: $accessToken");
    print("Refresh Token: $refreshToken");
    return refreshToken;
  } else {
    print("Failed to get tokens: ${response.statusCode}");
    return null;
  }
}
  // Add a return statement h


