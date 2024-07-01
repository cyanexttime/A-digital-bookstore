import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oms/API/get_manga_details.dart';
import 'package:oms/view/SimilarMangasView.dart';
import 'package:oms/widgets/info_text.dart';
import '/common/extensions/extensions.dart';
import '/common/styles/paddings.dart';
import '/common/styles/text_styles.dart';
import '/common/widgets/ios_back_button.dart';
import '/common/widgets/network_image_view.dart';
import '/common/widgets/read_more_text.dart';
import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '/models/manga_details.dart';
import '/models/picture.dart';

class MangaDetailsScreen extends StatelessWidget {
  const MangaDetailsScreen({
    super.key,
    required this.id,
  });

  final int id;

  static const routeName = '/manga-details';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMangaDetailsApi(id: id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        if (snapshot.data != null) {
          final manga = snapshot.data;
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMangaImage(
                    imageUrl: manga!.mainPicture.large,
                  ),
                  Padding(
                    padding: Paddings.defaultPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        _buildMangaName(
                          name: manga.title,
                          englishName: manga.alternativeTitles.en,
                        ),

                        const SizedBox(height: 20),

                        // Description
                        ReadMoreText(
                          longText: manga.synopsis,
                        ),

                        const SizedBox(height: 10),

                        _buildMangaInfo(
                          manga: manga,
                        ),

                        const SizedBox(height: 20),

                        manga.background.isNotEmpty
                            ? _buildMangaBackground(
                                background: manga.background,
                              )
                            : const SizedBox.shrink(),

                        const SizedBox(height: 20),
                        //Image Gallery
                        _buildMangaImages(pictures: manga.pictures),

                        const SizedBox(height: 20),

                        // Related Mangas
                        SimilarMangaView(
                          mangas: manga.relatedManga
                              .map((relatedManga) => relatedManga.node)
                              .toList(),
                          labels: 'Related Manga',
                        ),

                        const SizedBox(height: 20),

                        // Recommendations
                        SimilarMangaView(
                          mangas: manga.recommendations
                              .map((mangaRec) => mangaRec.node)
                              .toList(),
                          labels: 'Recommendations',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ErrorScreen(
          error: snapshot.error.toString(),
        );
      },
    );
  }

  Widget _buildMangaImage({
    required String imageUrl,
  }) =>
      Stack(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            height: 400,
            width: double.infinity,
          ),
          Positioned(
            top: 30,
            left: 20,
            child: Builder(builder: (context) {
              return IosBackButton(
                onPressed: Navigator.of(context).pop,
              );
            }),
          ),
        ],
      );

  Widget _buildMangaName({
    required String name,
    required String englishName,
  }) =>
      Builder(builder: (context) {
        return Text(
          englishName,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor),
        );
      });

  Widget _buildMangaInfo({
    required MangaDetails manga,
  }) {
    String genres = manga.genres.map((genre) => genre.name).join(', ');
    String otherNames =
        manga.alternativeTitles.synonyms.map((title) => title).join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoText(label: 'Genres: ', info: genres),
        InfoText(label: 'Start date: ', info: manga.startDate),
        InfoText(label: 'End date: ', info: manga.endDate),
        InfoText(label: 'Volumes: ', info: manga.numVolumes.toString()),
        InfoText(label: 'Volumes: ', info: manga.numChapters.toString()),
        InfoText(label: 'Status: ', info: manga.status),
        InfoText(label: 'Other Names: ', info: otherNames),
        InfoText(label: 'English Name: ', info: manga.alternativeTitles.en),
        InfoText(label: 'Japanese Name: ', info: manga.alternativeTitles.ja),
      ],
    );
  }

  Widget _buildMangaBackground({
    required String background,
  }) {
    return WhiteContainer(
      child: Text(
        background,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildMangaImages({
    required List<Picture> pictures,
  }) {
    return Column(
      children: [
        Text(
          'Image Gallery',
          style: TextStyles.smallText,
        ),
        const SizedBox(
          height: 5,
        ),
        GridView.builder(
          itemCount: pictures.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 9 / 16,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final image = pictures[index];
            // final largeImage = pictures[index].large;
            return SizedBox(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NetworkImageView(url: image.large),
                      ),
                    );
                  },
                  child: Image.network(
                    image.medium,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
