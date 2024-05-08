import 'package:flutter/material.dart';
import 'package:oms/API/get_book_by_ranking_type.dart';
import 'package:oms/core/screens/error_screen.dart';
import 'package:oms/core/widgets/loader.dart';
import 'package:oms/screen/manga_screen.dart';
import 'package:oms/widgets/TopMangasList.dart';

class ViewAllManga extends StatelessWidget {
  const ViewAllManga(
      {super.key, required this.rankingType, required this.limit});
  final String rankingType;
  final String limit;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMangaByRankingType(rankingType: rankingType, limit: 3),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.data != null) {}
          return ErrorScreen(
            error: snapshot.error.toString(),
          );
        });
  }
}
