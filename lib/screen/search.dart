
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oms/API/get_filename_image.dart';
import 'package:oms/API/get_list_apiclient.dart';
import 'package:oms/API/get_mangas_by_search_api.dart';


String query = '';
List dataList = [];

class searchScreen extends StatefulWidget {
  const searchScreen({super.key});
  @override
  State<searchScreen> createState() => _Search();
}

class _Search extends State<searchScreen>  {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LoadData();
    });
  }

  Future<void> LoadData() async {
    final test = ListAPI();
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

  Future<String?> GetImage({required final query}) async {
    final imageData = await GetFileNameImage(query: query);
    if (imageData.isNotEmpty) {
      return imageData['data']['attributes']['fileName'];
    }
    return null;
  }

  Widget SearchBar(){
  return TextField(
    onChanged: (value) => loadAnimes(value),
    style: const TextStyle(color: Color(0xff5D4242)),
    decoration:InputDecoration(
      filled: true,
      fillColor: const Color(0xffF1DCD1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        ),
      hintText: 'Search manga',
      prefixIcon: const Icon(
        Icons.search, color: Color(0xff5D4242)
      ),
      ),
    );
  }

  Widget SearchResults(){
    return ListView.builder(
      itemCount: dataList.length,
  
      itemBuilder: (context, index) {
      final manga = dataList[index];
      final coverID = getCoverID(manga['relationships']);
      final ID = manga['id'];
      final title = manga['attributes']['title']['en'];
      final status = manga['attributes']['status'];

      return FutureBuilder<String?>(
      future: GetImage(query: coverID ?? ''),
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
                            
                            child:Container(
                              padding: const EdgeInsets.all(3),
                              child:Card(
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
  Widget build (BuildContext context)
  {
    return Scaffold(
      backgroundColor: const Color(0xFFF1DCD1),
      appBar: AppBar(
        title: const Text(
          'SEARCH',
          style: TextStyle(
          color: Color(0xff150B0B),
          fontSize: 22,
          fontWeight: FontWeight.bold,
          )
        ),
        backgroundColor: const Color(0xFF219F94),
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SizedBox(
            height: 80,
            child:SearchBar(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 280, // 85 is the total height of other widgets
            child: SearchResults(),
          ),
          ],

        ),
       ),
        )
      );
  }
  
}

