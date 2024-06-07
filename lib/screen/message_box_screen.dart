import 'package:flutter/material.dart';
import 'package:oms/API/update_manga_reading_status.dart';
import 'package:oms/screen/chapter.dart';

class MessageBoxScreen {
  
  final _selectedOption = ValueNotifier<String>(currentStatus);
  List<String> _options = ['None', 'Reading', 'On Hold', 'Dropped', 'Plan to Read', 'Completed', 'Re-Reading'];
  final checkNotification = ValueNotifier<bool>(false); 
  void showMessageBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add to library'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Choose the option you want to add to the library(Reading status)'),
              Row(children: [
                const SizedBox(height: 16.0),
                ValueListenableBuilder<String>(
                  valueListenable: _selectedOption,
                  builder: (context, value, child) {
                    return DropdownButton<String>(
                      value: value,
                      onChanged: (value) {
                        _selectedOption.value = value!;
                      },
                      items: _options.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    );
                  },
                  ),  
                  ValueListenableBuilder<bool>(
                  valueListenable: checkNotification,
                  builder: (context, value, child) {
                    return IconButton(
                      icon: Icon(value ? Icons.notifications : Icons.notifications_off),
                      onPressed: () {
                        checkNotification.value = !value;
                      },
                    );
                  },
                ),
              ]
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle the "Save" button press
                PostUpdateReadingStatus(idmanga: mangaID, tempstatus: _selectedOption.value).then((value) {
                  if (value == '200') {
                    print('Updated reading status');
                  } else {
                    print('Failed to update reading status');
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

