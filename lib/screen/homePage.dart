import 'package:flutter/material.dart';

import 'package:oms/Constants/appColor.dart';
import 'package:oms/Constants/constants.dart';
import 'package:oms/models/manga.dart';

import 'package:oms/screen/manga_screen.dart';
import '/screen/library_screen.dart';
import '/screen/search_screen.dart';
import '/screen/settings_screen.dart';
import '/screen/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.index});

  final int? index;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    if (widget.index != null) {
      _selectedIndex = widget.index!;
    }
    super.initState();
  }

  final _destinations = [
    const NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    const NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
    const NavigationDestination(
        icon: Icon(Icons.library_add), label: 'Library'),
    const NavigationDestination(
        icon: Icon(Icons.settings), label: 'Notifications'),
    const NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
  ];
  get _screens => const [
        MangaScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    if (_screens.isEmpty) {
      return Center(child: Text('No screens available'));
    } else {
      return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          elevation: 12,
          backgroundColor: AppColor.darkCyan,
          selectedIndex: _selectedIndex,
          destinations: _destinations,
          onDestinationSelected: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
        
        ),
      );
    }
  }
}