
import 'package:flutter/material.dart';
import 'package:oms/models/items_model.dart';

class BookmarkBloc extends ChangeNotifier{
  int _count = 0;
  List<ItemModel>  items = [];

  void init()
  {
    _count = 0;
    items = [];
  }
  void AddCount(){
    _count++;
    notifyListeners();
  }
  void SubCount(){
    _count--;
    notifyListeners();
  }

  void SetCount(int count){
    _count = count;
    notifyListeners();
  }
  void AddItem(ItemModel item){
    items.add(item);
    notifyListeners();
  }

  void RemoveItem(ItemModel item) {
    items.removeWhere((element) => element.nameChapter == item.nameChapter);
    SubCount(); // Decrease count when an item is removed
    notifyListeners();
  }

  int get count {
    return _count;
  }

  List<ItemModel> get itemsList {
    return items;
  }

  void clearItems() {
    items.clear();
    notifyListeners();
  }
}