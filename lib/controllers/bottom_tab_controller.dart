import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomTabController extends GetxController {
  final RxInt _selectedIndex = 0.obs;

  final _pages = <Widget>[];

  List<Widget> get pages => _pages;
  int get selectedIndex => _selectedIndex.value;
  void setTabIndex(int index) => _selectedIndex(index);
}
