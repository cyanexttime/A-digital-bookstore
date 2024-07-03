import 'dart:convert';





import 'package:http/http.dart' as http;
import 'package:oms/components/api_variables.dart';


Map<String,dynamic> data = {};
Future<String?> GetToken() async {
  final creds = {
      "grant_type": "refresh_token",
      "refresh_token":  apiVariables.refreshToken,
      "client_id": apiVariables.clientId,
      "client_secret": apiVariables.secretId,
    };
    print(apiVariables.refreshToken);
   final response = await http.post(
      Uri.parse("https://auth.mangadex.org/realms/mangadex/protocol/openid-connect/token"),
      body: creds,
    );
    
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse["access_token"];
      } else {
        print('Failed to load access token');
        return null;
      }
}
  
  // Add a return statement h


