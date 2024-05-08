import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oms/API/get_book_by_ranking_type.dart';
import 'package:oms/core/screens/error_screen.dart';
import 'package:oms/core/widgets/loader.dart';
import 'package:oms/widgets/MangaTile.dart';

class FeaturedMangas extends StatelessWidget {
  const FeaturedMangas(
      {super.key, required, required this.rankingType, required this.labels});

  final String rankingType;
  final String labels;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMangaByRankingType(rankingType: rankingType, limit: 10),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.data != null) {
            final mangas = snapshot.data;

            return Column(
              children: [
                //title part
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        labels,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View all'),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 300,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: mangas!.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 10);
                    },
                    itemBuilder: (context, index) {
                      final manga = mangas.elementAt(index);
                      return MangaTile(
                        manga: manga.node,
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return ErrorScreen(error: snapshot.error.toString());
        });
  }
}
