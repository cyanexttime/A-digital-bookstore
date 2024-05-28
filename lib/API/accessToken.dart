
import 'dart:convert';



import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:http/http.dart';


Map<String,dynamic> data = {};
Future<String?> GetToken({
  required String query,
}) async {

  final creds = {
      "grant_type": "refresh_token",
      "refresh_token": query,
      "client_id": "personal-client-b899bbf6-0f42-4136-96a2-74fbeb8d9176-dd343205",
      "client_secret": "R4Lopt85Qgv7keEEGLMdK7dRCCW5kCCH",
    };

   final response = await http.post(
      Uri.parse("https://auth.mangadex.org/realms/mangadex/protocol/openid-connect/token"),
      body: creds,
    );
    
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse["access_token"];
      } else {
        print('Failed to load access token');
        return null;
      }
}
  
  // Add a return statement h


