
import 'dart:convert';



import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:oms/API/accessToken.dart';
import 'package:oms/API/authencation.dart';



Future<String> PostMangaRating( {
  required String idmanga,
  required int rating,
}) async {
  final String baseUrl = "https://api.mangadex.org/rating";
  final String? sessionToken = await GetToken();
  final response = await http.post(
    Uri.parse("$baseUrl/$idmanga"),
    headers: {
      "Authorization": "Bearer $sessionToken",
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, int>{
      'rating': rating,
    }),
  );
  if (response.statusCode == 200) {
      print("sc");
      return (response.statusCode).toString();
  }
  else {
      print('Error: ${response.statusCode}');
      return (response.statusCode).toString();
  }
}
  // Add a return statement h


