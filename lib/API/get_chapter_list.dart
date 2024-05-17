
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:http/http.dart';



Future<List<dynamic>> GetChapterList({
  required String query,
}) async {

  final String baseUrl = "https://api.mangadex.org/manga";
  print(query);
  List<dynamic> data = [];
  try{
    final response = await http.get(
    Uri.parse('$baseUrl/$query/feed')
  );
  print('$baseUrl/$query/feed');
  if (response.statusCode == 200) {
      data = json.decode(response.body)['data'];
      print(data);
      // một danh sách các node anime trong khóa data của api
      return data;
    } 
  else{
      print('Error: ${response.statusCode}');
    }
  }
  catch(e){
      if (e is ClientException) {
      // Handle the exception here
      print('Failed to load data: $e');
    }
  }
  // Add a return statement here
  return []; 
}


