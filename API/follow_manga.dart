import 'package:http/http.dart' as http;
import 'package:oms/API/accessToken.dart';

// ignore: non_constant_identifier_names
Future<String> PostMangaToMangaList({
  required String query,
}) async {
  const String baseUrl = "https://api.mangadex.org";
  final String? sessionToken = await GetToken();
  final response = await http.post(
    Uri.parse("$baseUrl/manga/$query/follow"),
    headers: {"Authorization": "Bearer $sessionToken"},
  );
  if (response.statusCode == 200) {
    return (response.statusCode).toString();
  } else {
    return (response.statusCode).toString();
  }
}
  // Add a return statement h


