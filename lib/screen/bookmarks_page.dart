
import 'package:flutter/material.dart';
import 'package:oms/provider/bookmark_model.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});
  @override
    State<BookmarksPage> createState() => _BookmarksPageState ();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    var bookmarkBloc = Provider.of<BookmarkBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarks"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              itemCount: bookmarkBloc.items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("chapter ${bookmarkBloc.items[index].nameChapter}"),

                );
              },
            ),
          ],
        ),
      ),
    );
  }
}