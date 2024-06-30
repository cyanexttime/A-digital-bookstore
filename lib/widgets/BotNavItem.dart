import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BottomNavigationBarItem BotNavItem(IconData icon, String title){
  return BottomNavigationBarItem(
      icon: Icon(icon),
      label: title,
  );
}