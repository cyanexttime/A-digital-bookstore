
// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';





import 'package:http/http.dart' as http;
import 'package:oms/API/accessToken.dart';



Future<String> PostMangaReadMarkers( {
  required String idmanga,
  required String idchapter,
  bool updateHistory = true,
}) async {
  const String baseUrl = "https://api.mangadex.org/manga";
  final String? sessionToken = await GetToken();
  final response = await http.post(
    Uri.parse("$baseUrl/$idmanga/read"),
    headers: {
      "Authorization": "Bearer $sessionToken",
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
       'chapterIdsRead': [idchapter],
    }),
  );
  if (response.statusCode == 200) {
    print("rs" );
      return (response.statusCode).toString();
  }
  else {
      return (response.statusCode).toString();
  }
}
  // Add a return statement h


