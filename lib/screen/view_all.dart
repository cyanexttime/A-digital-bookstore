import 'package:flutter/material.dart';
import 'package:oms/API/get_book_by_ranking_type.dart';
import 'package:oms/core/screens/error_screen.dart';
import 'package:oms/core/widgets/loader.dart';
import 'package:oms/view/RankedMangaListview.dart';

class ViewAllManga extends StatelessWidget {
  const ViewAllManga(
      {super.key, required this.rankingType, required this.label});
  final String rankingType;
  final String label;
  @override
  Widget build(BuildContext context) {
        final Color backgroundColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : const Color(0xFFF1DCD1);
    return Scaffold(
      appBar: AppBar(
        title: Text(label,
        style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF219F94),
      ),
      body: FutureBuilder(
          future: getMangaByRankingType(rankingType: rankingType, limit: 500),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            if (snapshot.data != null) {
              return RankedMangaListView(
                mangas: snapshot.data!,
              );
            }
            return ErrorScreen(
              error: snapshot.error.toString(),
            );
          }),
          backgroundColor: backgroundColor,
    );
  }
}
