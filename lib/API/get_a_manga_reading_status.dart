
import 'dart:convert';



import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:oms/API/accessToken.dart';


Future<String?> GetAMangaReadingStatus( {
  required String query,
}) async {
  final String baseUrl = "https://api.mangadex.org/manga";
  final String? sessionToken = await GetToken();
  final response = await http.get(
    Uri.parse("$baseUrl/$query/status"),
    headers: {
      "Authorization": "Bearer $sessionToken"
    },
  );
  if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data["status"]);
      return data["status"];
  }
  else {
      return (response.statusCode).toString();
  }
}


