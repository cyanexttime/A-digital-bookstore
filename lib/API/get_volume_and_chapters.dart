import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:oms/API/get_chapter_information.dart';

Future<Map<String, dynamic>> GetVolumesAndChapters({
  required String query,
}) async {
  final String baseUrl = "https://api.mangadex.org/manga";
  Map<String, dynamic> data = {};
  try {
    final response = await http.get(Uri.parse('$baseUrl/$query/aggregate'));
    if (response.statusCode == 200) {
      var datajson = json.decode(response.body);
      data = datajson != null ? datajson : {};
      // một danh sách các node anime trong khóa data của api
      return data;
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    if (e is ClientException) {
      // Handle the exception here
      print('Failed to load data: $e');
    }
  }
  // Add a return statement here
  return {};
}
