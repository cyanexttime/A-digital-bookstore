





// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:http/http.dart' as http;
import 'package:oms/API/accessToken.dart';


Future<String> DeleteMangaInMangaList( {
  required String query,
}) async {
  const String baseUrl = "https://api.mangadex.org";
  final String? sessionToken = await GetToken();
  print(sessionToken);
  final response = await http.delete(
    Uri.parse("$baseUrl/manga/$query/follow"),
    headers: {
      "Authorization": "Bearer $sessionToken"
    },
  );
  if (response.statusCode == 200) {
      return (response.statusCode).toString();
  }
  else {
      print('Error: ${response.statusCode}');
      return (response.statusCode).toString();
  }
}



