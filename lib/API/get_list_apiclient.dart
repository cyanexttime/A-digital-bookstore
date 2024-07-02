import 'package:http/http.dart' as http;


Future<String> ListAPI( 
) async {
  final url = Uri.parse('https://api.mangadex.org/client');
  final headers = {
    'accept': 'application/json',
  };

  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
      return (response.statusCode).toString();
  }
  else {
      print('Error: ${response.statusCode}');
      return (response.statusCode).toString();
  }
}