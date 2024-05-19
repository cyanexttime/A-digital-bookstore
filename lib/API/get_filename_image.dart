
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



Future<Map<String,dynamic>> GetFileNameImage({
  required String query,
}) async {

  final String baseUrl = "https://api.mangadex.org/cover";
  final response = await http.get(
    Uri.parse('$baseUrl/$query')
  );
  Map<String,dynamic> data = {};
  if (response.statusCode == 200) {
    data = json.decode(response.body);
    // một danh sách các node anime trong khóa data của api
    return data;
  } 
  // Add a return statement here
  return {}; 
}


