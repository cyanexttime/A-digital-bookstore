
import 'dart:convert';



import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:oms/API/accessToken.dart';
import 'package:oms/API/authencation.dart';


// Future<String> DeleteMangaInMangaList( {
//   required String query,
// }) async {
//   final String baseUrl = "https://api.mangadex.org";
//   final String? reshesToken = await GetResfreshingToken();
//   final String? sessionToken = await GetToken(query: reshesToken ?? '');
//   final response = await http.delete(
//     Uri.parse("$baseUrl/manga/$query/follow"),
//     headers: {
//       "Authorization": "Bearer $sessionToken"
//     },
//   );
//   if (response.statusCode == 200) {
//       return (response.statusCode).toString();
//   }
//   else {
//       print('Error: ${response.statusCode}');
//       return (response.statusCode).toString();
//   }
// }
  // Add a return statement h


