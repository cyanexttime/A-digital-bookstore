import 'package:flutter/material.dart';
import 'package:oms/common/styles/paddings.dart';
import 'package:oms/view/FeaturedMangas.dart';
import 'package:oms/widgets/TopMangasList.dart';
import 'package:oms/screen/profile.dart';
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
      appBar: AppBar(
        title: const Text('ODESSEY',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );},
            icon: const Icon(Icons.person),
          ),
        ],
        backgroundColor: const Color(0xFF219F94),
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
      backgroundColor: backgroundColor,
    );
  }
}
