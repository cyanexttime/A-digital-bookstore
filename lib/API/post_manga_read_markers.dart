
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
    Uri.parse("$baseUrl/$idmanga/read?updateHistory=$updateHistory"),
    headers: {
      "Authorization": "Bearer $sessionToken",
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
       'chapterIdsRead': [idchapter],
    }),
  );
  if (response.statusCode == 200) {
      print("sc post read markers");
      return (response.statusCode).toString();
  }
  else {
      print('Error: ${response.statusCode}');
      return (response.statusCode).toString();
  }
}
  // Add a return statement h


