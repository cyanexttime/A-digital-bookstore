import 'package:flutter/material.dart';
import 'package:oms/API/get_book_by_ranking_type.dart';
import 'package:oms/core/screens/error_screen.dart';
import 'package:oms/core/widgets/loader.dart';
import 'package:oms/widgets/TopMangasImageSlider.dart';

class TopMangasList extends StatefulWidget {
  const TopMangasList({super.key});

  @override
  State<TopMangasList> createState() => _TopMangasListState();
}

class _TopMangasListState extends State<TopMangasList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMangaByRankingType(rankingType: 'all', limit: 4),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.data != null) {
            final mangas = snapshot.data!.toList();
            return TopMangasImageSlider(mangas: mangas);
          }
          return ErrorScreen(error: snapshot.error.toString());
        });
  }
}
