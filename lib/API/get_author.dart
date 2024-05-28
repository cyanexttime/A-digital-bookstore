
import 'dart:convert';


import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:oms/chapter.dart';


Map<String,dynamic> data = {};
Future<Map<String,dynamic>> GetAuthor({
  required String query,
}) async {
  final String baseUrl = "http://api.mangadex.org/author";
  try{
    final response = await http.get(
      Uri.parse('$baseUrl/$query'),
    ).timeout(const Duration(seconds: 10));
    print('$baseUrl/$query');
    if (response.statusCode == 200) {
        data= json.decode(response.body);
        Map<String,dynamic> check = data != null ? data : {};
        // một danh sách các node anime trong khóa data của api
        return check;
    }
    else {
      print('Error: ${response.statusCode}');
    }
  }catch(e){
    print('Error: $e');
  }
  return {};
}
  // Add a return statement h

