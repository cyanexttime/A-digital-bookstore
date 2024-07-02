// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oms/API/get_all_reading_status.dart';
import 'package:oms/API/get_manga_info.dart';
import 'package:oms/components/api_variables.dart';
import 'package:oms/components/get_coverID.dart';
import 'package:oms/components/get_image.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with AutomaticKeepAliveClientMixin {
  Map<String, dynamic> dataReadingStatus = {};
  final Map<String, Future<List<dynamic>>> _futures = {};
  String selectedValue = 'All';
  bool isLoading = false;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => CheckLogin());
  }

  Future<void> CheckLogin() async {
    if (!apiVariables.isLogin) {
      Navigator.pushNamed(context, 'signInMangadex');
    } else {
      setState(() {
        isLoading = true;
      });
      dataReadingStatus = await GetALLMangaReadingStatus(query: selectedValue);
      if (dataReadingStatus.isEmpty) {
        setState(() {
          isLoading = false;
          if (kDebugMode) {
            print("da vao ");
          }
        });
        return;
      }
      setState(() {
        dataReadingStatus['statuses'].keys.forEach((mangaID) {
          _futures[mangaID] = _fetchMangaData(mangaID);
        });
        isLoading = false;
      });
    }
  }

  Future<List<dynamic>> _fetchMangaData(String mangaID) async {
    final mangaInfo = await GetMangaInfo(query: mangaID);
    final coverID = getCoverID(mangaInfo['data']['relationships']);
    final getImageString = await GetImage(query: coverID);
    final title = mangaInfo['data']['attributes']['title']['en'] ?? '';
    final description =
        mangaInfo['data']['attributes']['description']['en'] ?? '';
    return [mangaInfo, getImageString, title, description];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Color backgroundColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : const Color(0xFFF1DCD1);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'LIBRARY',
          style: TextStyle(
            
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF219F94),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedValue,
              items: [
                'All',
                'Reading',
                'Completed',
                'Dropped',
                'Plan to read',
                'Re-Reading',
                'On Hold'
              ]
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              onChanged: (newValue) {
                setState(() async {
                  selectedValue = newValue!;
                  await CheckLogin(); // Reload data based on the selected filter
                });
              },
            ),
            Expanded(child: _buildResults(selectedValue)),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(String value) {
    final dataManga = dataReadingStatus['statuses'];
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (dataManga == null) {
      return const Center(child: Text('No Manga'));
    } else {
      final mangaEntries = dataManga.entries.toList();
      return GridView.builder(
        itemCount: mangaEntries.length,
        itemBuilder: (context, index) {
          final mangaEntry = mangaEntries[index];
          final mangaID = mangaEntry.key;
          return FutureBuilder<List<dynamic>>(
            future: _futures[mangaID],
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final imageUrl =
                    'https://uploads.mangadex.org/covers/$mangaID/${snapshot.data?[1]}';
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[300]!, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            placeholder: (context, url) =>
                                const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          snapshot.data?[2] ?? 'No title',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: Text(
                          snapshot.data?[3] ?? 'No description',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'chapter',
                                arguments: mangaID);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Read'),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.6,
        ),
      );
    }
  }
}
