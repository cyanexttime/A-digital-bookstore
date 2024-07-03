import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/screen/manga_details_screen.dart';
import '/models/manga.dart';

class MangaListTile extends StatelessWidget {
  const MangaListTile({
    super.key,
    required this.manga,
    this.rank,
  });

  final Manga manga;
  final int? rank;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MangaDetailsScreen(id: manga.node.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 16.0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image
                SizedBox(
                  height: 100,
                  width: 150,
                  child: CachedNetworkImage(
                    imageUrl: manga.node.mainPicture.medium,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 20),

                // Anime Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      rank != null
                          ? MangaRankBadge(rank: rank!)
                          : const SizedBox.shrink(),
                      const SizedBox(height: 10),
                      Text(
                        manga.node.title,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MangaRankBadge extends StatelessWidget {
  const MangaRankBadge({
    super.key,
    required this.rank,
  });

  final int rank;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(12.0),
      color: Colors.amberAccent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 3.0,
        ),
        child: Text(
          'Rank $rank',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
