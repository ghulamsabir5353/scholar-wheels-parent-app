import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scholarwheels/controllers/main.controller.dart';
import 'package:scholarwheels/controllers/network_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';

import '../controllers/bottom_tab_controller.dart';

class TabScreen extends StatefulWidget {
  static const route = '/tab_screen';
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final mainController = Get.put(MainController());
  final controller = Get.put(BottomTabController());
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkService>(
      builder: (context, network, child) {
        return Obx(
          () => Scaffold(
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: Material(
              elevation: 2,
              color: Colors.grey.shade50,
              shadowColor: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: Get.width,
                height: 67,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          tabItem(
                            img: 'assets/images/svg/home.svg',
                            index: 0,
                            onChange: () {
                              controller.setTabIndex(0);
                            },
                          ),
                          tabItem(
                            index: 1,
                            img: 'assets/images/svg/children.svg',
                            onChange: () {
                              controller.setTabIndex(1);
                            },
                          ),
                          tabItem(
                            img: 'assets/images/svg/find.svg',
                            index: 2,
                            onChange: () {
                              controller.setTabIndex(2);
                            },
                          ),
                          tabItem(
                            index: 3,
                            img: 'assets/images/svg/contracts.svg',
                            onChange: () {
                              controller.setTabIndex(3);
                            },
                          ),
                          tabItem(
                            img: 'assets/images/svg/chat.svg',
                            index: 4,
                            onChange: () {
                              controller.setTabIndex(4);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                controller.pages[controller.selectedIndex],
                if (!network.isConnected)
                  Positioned(
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      alignment: Alignment.center,
                      color: Colors.white,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Image.asset(
                              'assets/images/png/no-signal.png',
                              width: 150,
                              height: 150,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wifi_off,
                                color: Colors.black,
                                size: 32,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "No Internet Connection",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                height: 47,
                                width: 100,
                                onPressed: () {
                                  // mainController.getHomeData();
                                },
                                title: "Retry",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  tabItem({img, onChange, png, index = 0}) {
    return InkWell(
      autofocus: false,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onChange,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            png ??
            SvgPicture.asset(
              img,
              colorFilter: ColorFilter.mode(
                controller.selectedIndex == index
                    ? AppColor.primary
                    : AppColor.bottomNavigationGrayColor,
                BlendMode.srcIn,
              ),
            ),
      ),
    );
  }
}
