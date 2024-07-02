import 'package:flutter/material.dart';
import 'package:oms/Constants/appColor.dart';
import 'package:oms/provider/bookmark_model.dart';
import 'package:provider/provider.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});
  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    var bookmarkBloc = Provider.of<BookmarkBloc>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF1DCD1),
      appBar: AppBar(
        title: const Text("Bookmarks",
         style: TextStyle(
            color: Color(0xff150B0B),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:AppColor.darkCyan, // Thay đổi màu sắc AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Thêm padding cho toàn bộ nội dung
          child: Column(
            children: [
              ListView.builder(
                itemCount: bookmarkBloc.items.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0), // Thêm khoảng cách giữa các mục
                    child: ListTile(
                      leading: const Icon(Icons.bookmark, color: Color(0xFF219F94)), // Thêm biểu tượng bookmark
                      title: Text(
                        "Chapter ${bookmarkBloc.items[index].nameChapter}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Translation Language:${bookmarkBloc.items[index].transLanguage ?? ''}", // Bạn có thể thêm thông tin phụ
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[600]), // Biểu tượng mũi tên
                      onTap: () {
                        Navigator.pushNamed(context, 'chapterContent', arguments: bookmarkBloc.items[index].chapterID);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
