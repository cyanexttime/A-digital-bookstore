import 'package:flutter/material.dart';
import 'package:oms/common/styles/text_styles.dart';
import 'package:oms/models/manga_node.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MangaTile extends StatelessWidget {
  const MangaTile({
    super.key,
    required this.manga,
  });
  final MangaNode manga;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
                imageUrl: manga.mainPicture.medium,
                fit: BoxFit.cover,
                height: 200),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            manga.title,
            maxLines: 3,
            style: TextStyles.mediumText,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
