
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;



Future<List<dynamic>> getMangasBySearchApi({
  required String query,
}) async {

  const String baseUrl = "https://api.mangadex.org";
  final response = await http.get(
    Uri.parse('$baseUrl/manga?title=$query')
  ).timeout(const Duration(seconds: 5));
  List<dynamic> data = [];
  if (response.statusCode == 200) {
    data = json.decode(response.body)['data'];
    print(data);
    // một danh sách các node anime trong khóa data của api
    return data;
  } 
  // Add a return statement here
  return []; 
}


