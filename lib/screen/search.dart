import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oms/API/accessToken.dart';
import 'package:oms/API/authencation.dart';
import 'package:oms/API/get_filename_image.dart';
import 'package:oms/API/get_list_apiclient.dart';
import 'package:oms/API/get_mangas_by_search_api.dart';
import 'package:oms/Constants/appColor.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  List dataList = [];
  Map<String, String?> imageUrlMap = {};
  String query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    // Your implementation of ListAPI goes here.
  }

  Future<void> loadAnimes(String value) async {
    final data = await getMangasBySearchApi(query: value);
    setState(() {
      dataList = data;
    });
  }

  String? getCoverID(List<dynamic> relationships) {
    for (var relationship in relationships) {
      if (relationship['type'] == 'cover_art') {
        return relationship['id'];
      }
    }
    return null;
  }

  Future<String?> getImage({required String query}) async {
    if (imageUrlMap.containsKey(query)) {
      return imageUrlMap[query];
    } else {
      final imageData = await GetFileNameImage(query: query);
      if (imageData.isNotEmpty) {
        final imageUrl = imageData['data']['attributes']['fileName'];
        setState(() {
          imageUrlMap[query] = imageUrl;
        });
        return imageUrl;
      }
    }
    return null;
  }

  Widget searchBar() {
    return TextField(
      onChanged: (value) => loadAnimes(value),
      style: const TextStyle(color: Color(0xff5D4242)),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffF1DCD1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        hintText: 'Search manga',
        prefixIcon: const Icon(Icons.search, color: Color(0xff5D4242)),
      ),
    );
  }

  Widget searchResults() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final manga = dataList[index];
        final coverID = getCoverID(manga['relationships']);
        final ID = manga['id'];
        final title = manga['attributes']['title']['en'];
        final status = manga['attributes']['status'];

        return FutureBuilder<String?>(
          future: getImage(query: coverID ?? ''),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final imageUrl = snapshot.data != null
                  ? 'https://uploads.mangadex.org/covers/$ID/${snapshot.data}.512.jpg'
                  : null;

              return Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'chapter', arguments: ID);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(10.0), // Replace Padding with Container and margin
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (imageUrl != null)
                                Container(
                                  height: 130, // Adjust the height of the image
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(imageUrl),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Text(
                                title ?? 'No title',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                status ?? 'Unknown status',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // This line ensures the state is kept alive
    return Scaffold(
      backgroundColor: const Color(0xFFF1DCD1),
      appBar: AppBar(
        title: const Text(
          'SEARCH',
          style: TextStyle(
            color: Color(0xff150B0B),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.darkCyan,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              child: searchBar(),
            ),
            Expanded(
              child: searchResults(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
