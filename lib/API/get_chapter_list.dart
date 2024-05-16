
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;



Future<List<dynamic>> GetChapterList({
  required String query,
}) async {

  final String baseUrl = "https://api.mangadex.org/manga";
  print(query);
  final response = await http.get(
    Uri.parse('$baseUrl/$query/feed')
    
  );
  print('$baseUrl/$query/feed');
  List<dynamic> data = [];
  if (response.statusCode == 200) {
    data = json.decode(response.body)['data'];
    print(data);
    // một danh sách các node anime trong khóa data của api
    return data;
  } 
  else{
    print('Error: ${response.statusCode}');
  }
  // Add a return statement here
  return []; 
}


