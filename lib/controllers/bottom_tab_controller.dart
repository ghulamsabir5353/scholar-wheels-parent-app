import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/screens/chat/room_list_screen.dart';
import 'package:scholarwheels/screens/childrens/children_screen.dart';
import 'package:scholarwheels/screens/contracts/booking_contract_screen.dart';
import 'package:scholarwheels/screens/find_transport/find_transport_screen.dart';
import 'package:scholarwheels/screens/home/home_screen.dart';

class BottomTabController extends GetxController {
  final RxInt _selectedIndex = 0.obs;

  final _pages = <Widget>[
    HomeScreen(),
    ChildrenScreen(),
    FindTransportScreen(),
    BookingContractScreen(),
    RoomListScreen(),
  ];

  List<Widget> get pages => _pages;
  int get selectedIndex => _selectedIndex.value;
  void setTabIndex(int index) => _selectedIndex(index);
}
