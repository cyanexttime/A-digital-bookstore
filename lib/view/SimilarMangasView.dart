import 'package:flutter/material.dart';
import 'package:oms/API/get_book_by_ranking_type.dart';
import 'package:oms/core/screens/error_screen.dart';
import 'package:oms/core/widgets/loader.dart';
import 'package:oms/models/manga_node.dart';
import 'package:oms/screen/manga_details_screen.dart';
import 'package:oms/widgets/MangaTile.dart';

class SimilarMangaView extends StatelessWidget {
  const SimilarMangaView(
      {super.key, required, required this.mangas, required this.labels});

  final List<MangaNode> mangas;
  final String labels;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title part
        SizedBox(
          height: 50,
          child: Text(
            labels,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        SizedBox(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: mangas.length,
            separatorBuilder: (context, index) {
              return const SizedBox(width: 10);
            },
            itemBuilder: (context, index) {
              final manga = mangas.elementAt(index);

              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MangaDetailsScreen(
                        id: manga.id,
                      ),
                    ),
                  );
                },
                child: MangaTile(
                  manga: manga,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
