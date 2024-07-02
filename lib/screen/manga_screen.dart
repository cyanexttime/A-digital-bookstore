

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('ODESSEY'),
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
