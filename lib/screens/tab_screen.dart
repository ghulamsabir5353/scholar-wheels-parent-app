import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/main.controller.dart';
import 'package:scholarwheels/controllers/network_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.widgets/focus_manager.dart';
import 'package:scholarwheels/screens/common/app_drawer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/bottom_tab_controller.dart';

class TabScreen extends StatefulWidget {
  static const route = '/tab_screen';
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  // Controllers are now initialized via TabScreenBinding
  final mainController = Get.find<MainController>();
  final controller = Get.find<BottomTabController>();

  // Create a unique key for this Scaffold instance
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Update the controller's key reference after the first frame
    // This ensures the Scaffold is built and the key is valid
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        controller.rootScaffoldKey = _scaffoldKey;
        final status = await Permission.locationWhenInUse.status;
        if (!status.isGranted) {
          await Permission.locationWhenInUse.request();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ensure the controller has the current key reference
    controller.rootScaffoldKey = _scaffoldKey;

    return Consumer<NetworkService>(
      builder: (context, network, child) {
        return Obx(
          () => KeyboardNavigator(
            child: Scaffold(
              key: _scaffoldKey,
              resizeToAvoidBottomInset: false,
              drawer: AppDrawer(
                userName:
                    '${BaseHelper.currentUser.value.firstName ?? ''} ${BaseHelper.currentUser.value.surName ?? ''}',
                onSelectTab: (i) {
                  controller.setTabIndex(i);
                },
              ),
              bottomNavigationBar: SafeArea(
                top: false,
                bottom: true,
                child: Semantics(
                  label: 'Bottom navigation bar',
                  child: Material(
                    elevation: 0,
                    color: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: AppColor.bgGrayD9D8D8,
                            width: 0.5,
                          ),
                        ),
                      ),
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
                                  label: 'Home',
                                  onChange: () {
                                    controller.setTabIndex(0);
                                  },
                                ),
                                tabItem(
                                  index: 1,
                                  img: 'assets/images/svg/children.svg',
                                  label: 'Children',
                                  onChange: () {
                                    controller.setTabIndex(1);
                                  },
                                ),
                                tabItem(
                                  img: 'assets/images/svg/find.svg',
                                  index: 2,
                                  label: 'Find Transport',
                                  onChange: () {
                                    controller.setTabIndex(2);
                                  },
                                ),
                                tabItem(
                                  index: 3,
                                  img: 'assets/images/svg/contracts.svg',
                                  label: 'Contracts',
                                  onChange: () {
                                    controller.setTabIndex(3);
                                  },
                                ),
                                tabItem(
                                  img: 'assets/images/svg/chat.svg',
                                  index: 4,
                                  label: 'Chat',
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
                ),
              ),
              body: controller.pages[controller.selectedIndex],
            ),
          ),
        );
      },
    );
  }

  tabItem({img, onChange, png, index = 0, required String label}) {
    final bool isSelected = controller.selectedIndex == index;

    return Semantics(
      label: '$label tab',
      hint: isSelected ? 'Selected $label tab' : 'Tap to select $label tab',
      button: true,
      selected: isSelected,
      onTap: onChange,
      child: InkWell(
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
                  isSelected
                      ? AppColor.primary
                      : AppColor.bottomNavigationGrayColor,
                  BlendMode.srcIn,
                ),
              ),
        ),
      ),
    );
  }
}
