import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:oms/Constants/appColor.dart';
import 'package:oms/models/manga.dart';
import 'package:oms/models/manga_details.dart';
import 'package:oms/screen/chapter.dart';
import 'package:oms/screen/manga_details_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TopMangasImageSlider extends StatefulWidget {
  const TopMangasImageSlider({super.key, required this.mangas});
  final Iterable<Manga> mangas;
  @override
  State<TopMangasImageSlider> createState() => _TopMangasImageSliderState();
}

class _TopMangasImageSliderState extends State<TopMangasImageSlider> {
  int _currentPageIndex = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider.builder(
            carouselController: _controller,
            itemCount: widget.mangas.length,
            itemBuilder: (context, index, realIndex) {
              final manga = widget.mangas.elementAt(index);
              return TopMangaPicture(
                manga: manga,
              );
            },
            options: CarouselOptions(
              enlargeFactor: 0.22,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              aspectRatio: 16 / 9,
              viewportFraction: 0.88,
              autoPlay: true,
              enlargeCenterPage: true,
              initialPage: _currentPageIndex,
            ),
          ),
          const SizedBox(height: 20),
          AnimatedSmoothIndicator(
              activeIndex: _currentPageIndex,
              count: widget.mangas.length,
              effect: CustomizableEffect(
                activeDotDecoration: DotDecoration(
                  rotationAngle: 180,
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppColor.darkCyan,
                  width: 28.0,
                  height: 8.0,
                ),
                dotDecoration: DotDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    width: 28.0,
                    height: 8.0,
                    color: Theme.of(context).primaryColor),
              )),
        ],
      ),
    );
  }
}

class TopMangaPicture extends StatelessWidget {
  const TopMangaPicture({
    super.key,
    required this.manga,
  });
  final Manga manga;
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
        splashColor: Colors.white,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                manga.node.mainPicture.medium,
                fit: BoxFit.cover,
              ),
            )));
  }
}
