
import 'dart:convert';



import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:oms/API/accessToken.dart';
import 'package:oms/API/authencation.dart';


Future<String> PostMangaToMangaList( {
  required String query,
}) async {
  final String baseUrl = "https://api.mangadex.org";
  final String? sessionToken = await GetToken();
  final response = await http.post(
    Uri.parse("$baseUrl/manga/$query/follow"),
    headers: {
      "Authorization": "Bearer $sessionToken"
    },
  );
  if (response.statusCode == 200) {
      return (response.statusCode).toString();
      print('Success');
  }
  else {
      print('Error: ${response.statusCode}');
      return (response.statusCode).toString();
  }
}
  // Add a return statement h


