import 'package:flutter/material.dart';
import 'package:oms/API/get_a_manga_reading_status.dart';
import 'package:oms/API/post_manga_reading_status.dart';
import 'package:oms/screen/chapter.dart';



class MessageBoxScreen extends StatefulWidget {
  final String mangaID;

  MessageBoxScreen({required this.mangaID});

  @override
  _MessageBoxScreenState createState() => _MessageBoxScreenState();
}

class _MessageBoxScreenState extends State<MessageBoxScreen> {
  final List<String> _options = [
    'None',
    'Reading',
    'On Hold',
    'Dropped',
    'Plan to Read',
    'Completed',
    'Re-Reading'
  ];
  Map<String, String> changeTemp = {
    "on_hold": "On Hold",
    "reading": "Reading",
    "dropped": "Dropped",
    "plan_to_read": "Plan to Read",
    "completed": "Completed",
    "re_reading": "Re-Reading",
  };
  
  var selectedOption = 'None';

  @override
  void initState() {
    super.initState();
    LoadReadingStatus(widget.mangaID);
  }

  Future<void> LoadReadingStatus(String mangaID) async {
    final statusdata = await GetAMangaReadingStatus(query: mangaID);
    print(statusdata);
    if (statusdata != null) {
      setState(() {
        String currentStatus = statusdata.toString();
        selectedOption = changeTemp[currentStatus] ?? 'None';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFE0E0E0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add to library",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.0),
            const Text(
              'Choose the option you want to add to the library (Reading status)',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButton(
              value: selectedOption,
              onChanged: (newValue) {
                setState(() {
                  selectedOption = newValue!;
                });
              },
              items: _options.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    PostUpdateReadingStatus(
                      idmanga: mangaID,
                      tempstatus: selectedOption,
                    ).then((value) {
                      if (value == '200') {
                        print("Success");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update reading status'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
