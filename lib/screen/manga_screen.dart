import 'package:flutter/material.dart';
import 'package:oms/Constants/appColor.dart';
import 'package:oms/common/styles/paddings.dart';
import 'package:oms/view/FeaturedMangas.dart';
import 'package:oms/widgets/TopMangasList.dart';

class MangaScreen extends StatefulWidget {
  const MangaScreen({super.key});

  @override
  State<MangaScreen> createState() => _MangaScreenState();
}

class _MangaScreenState extends State<MangaScreen> {
  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : const Color(0xFFF1DCD1);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF219F94),
        title: const Text(
          'ODESSEY',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: TopMangasList(),
            ),
            Padding(
                padding: Paddings.noBottomPadding,
                child: Column(
                  children: [
                    SizedBox(
                      height: 350,
                      child: FeaturedMangas(
                        labels: 'Top Ranked',
                        rankingType: 'all',
                      ),
                    ),
                    SizedBox(
                      height: 350,
                      child: FeaturedMangas(
                        labels: 'Top Oneshots',
                        rankingType: 'oneshots',
                      ),
                    ),
                    SizedBox(
                      height: 350,
                      child: FeaturedMangas(
                        labels: 'Top Novels',
                        rankingType: 'novels',
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
