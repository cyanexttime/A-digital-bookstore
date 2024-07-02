
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oms/API/accessToken.dart';


Future<List<dynamic>> GetMangaReadMarkers( 
  {required final String query}
) async {
  const String baseUrl = "https://api.mangadex.org/manga";
  final String? sessionToken = await GetToken();
  final response = await http.get(
      Uri.parse("$baseUrl/$query/read"),
      headers: {
        "Authorization": "Bearer $sessionToken"
        },
      );
  
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    //print(decodedData['data']);
    return decodedData['data'];
  } else {
    print('Error: ${response.statusCode}');
    return [];
  }
}





