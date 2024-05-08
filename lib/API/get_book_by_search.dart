import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/config/app_config.dart';
import '/models/manga.dart';
import '/models/manga_info.dart';

Future<Iterable<Manga>> getMangasbySearchApi({
  required String query,
}) async {
  final baseUrl = "https://api.myanimelist.net/v2/anime?q=$query&limit=10";

  final response = await http.get(
    Uri.parse(baseUrl),
    headers: {
      'X-MAL-CLIENT-ID': clientId,
    },
  );

  if (response.statusCode == 200) {
    // Successful response
    final Map<String, dynamic> data = json.decode(response.body);
    MangaInfo mangaInfo = MangaInfo.fromJson(data);
    Iterable<Manga> mangas = mangaInfo.mangas;

    return mangas;
  } else {
    // Error handling
    debugPrint("Error: ${response.statusCode}");
    debugPrint("Body: ${response.body}");
    throw Exception("Failed to get data!");
  }
}
