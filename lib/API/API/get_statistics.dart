
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:http/http.dart';



Future<Map<String,dynamic>> GetStatistics({
  required String query,
}) async {

  final String baseUrl = "https://api.mangadex.org/statistics/manga/";
  Map<String,dynamic> data = {};
  try{
    final response = await http.get(
    Uri.parse('$baseUrl/$query')
  );
  if (response.statusCode == 200) {
      var datajson= json.decode(response.body);
      data = datajson != null ? datajson : {};
      // một danh sách các node anime trong khóa data của api
      return data['statistics']['$query'];
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
  return {}; 
}


