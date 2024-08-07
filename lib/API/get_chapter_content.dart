// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';


import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> GetChapterContent({
  required String query,
}) async {
  const String baseUrl = "https://api.mangadex.org/at-home/server";
  final response = await http.get(Uri.parse('$baseUrl/$query'));
  print('$baseUrl/$query/feed');
  Map<String, dynamic> data = {};
  if (response.statusCode == 200) {
    var jsonData = json.decode(response.body);
    data = jsonData ?? {};
    // một danh sách các node anime trong khóa data của api
    return data;
  } else {
    print('Error: ${response.statusCode}');
  }
  // Add a return statement here
  return {};
}
