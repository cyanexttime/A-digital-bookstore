import 'package:flutter/material.dart';
import 'package:oms/common/styles/paddings.dart';
import 'package:oms/models/manga.dart';
import 'package:oms/widgets/manga_list_tile.dart';

class RankedMangaListView extends StatelessWidget {
  const RankedMangaListView({
    super.key,
    required this.mangas,
  });

  final Iterable<Manga> mangas;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.defaultPadding,
      child: ListView.builder(
        itemCount: mangas.length,
        itemBuilder: (context, index) {
          final manga = mangas.elementAt(index);

          return MangaListTile(
            manga: manga,
          );
        },
      ),
    );
  }
}
