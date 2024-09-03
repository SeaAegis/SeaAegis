import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'package:provider/provider.dart';
import 'package:seaaegis/helpers/dark_mode.dart';
import 'package:seaaegis/providers/app_theme.dart';
import 'package:seaaegis/services/assets/vector.dart';
import 'package:seaaegis/views/alerts/alert_message.dart';
import 'package:seaaegis/views/favorites/favorite.dart';
import 'package:seaaegis/views/home/widgets/search_text_field.dart';
import 'package:seaaegis/views/notifications/notifications.dart';
import 'package:seaaegis/widgets/basic_app_bar.dart';
import 'package:seaaegis/widgets/theme_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeProvider>(builder: (context, provider, _) {
      return const Scaffold(
        appBar: BasicAppBar(
          isBack: false,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Hi, Vishnu!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SearchTextField(
                hintText: 'Search location...',
              ),
              Text(
                'Populor Beaches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PersistentTabController _controller;
  bool showNav = false;

  @override
  void initState() {
    super.initState();

    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const Favorites(),
      const AlertMessage(),
      const Notifications()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        contentPadding: 2,
        iconSize: 30,
        textStyle: const TextStyle(fontSize: 18),
        inactiveIcon: const Icon(Icons.home_outlined),
        icon: const Icon(Icons.home),
        title: "Home",
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        contentPadding: 2,
        iconSize: 30,
        textStyle: const TextStyle(fontSize: 18),
        icon: const Icon(Icons.favorite),
        title: "Favorite",
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        contentPadding: 2,
        iconSize: 30,
        textStyle: const TextStyle(fontSize: 18),
        // inactiveIcon: const Icon(Icons.calendar_month_outlined),
        icon: const Icon(Icons.warning),
        title: "Alerts",
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        contentPadding: 2,
        iconSize: 30,
        textStyle: const TextStyle(fontSize: 18),
        inactiveIcon: const Icon(Icons.notification_add),
        icon: const Icon(Icons.chat),
        title: "Notifications",
        inactiveColorPrimary: Colors.grey,
      ),
      // PersistentBottomNavBarItem(
      //   contentPadding: 2,
      //   iconSize: 30,
      //   textStyle: const TextStyle(fontSize: 18),
      //   inactiveIcon: const Icon(Icons.person_2_outlined),
      //   icon: const Icon(Icons.person),
      //   title: "Profile",
      //   inactiveColorPrimary: Colors.grey,
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),

      resizeToAvoidBottomInset: true,

      navBarHeight: 70,
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),

      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      // popAllScreensOnTapOfSelectedTab: true,
      // popActionScreens: PopActionScreensType.all,
      // itemAnimationProperties: const ItemAnimationProperties(
      //   duration: Duration(milliseconds: 200),
      //   curve: Curves.ease,
      // ),
      // screenTransitionAnimation: const ScreenTransitionAnimation(
      //   animateTabTransition: true,
      //   curve: Curves.ease,
      //   duration: Duration(milliseconds: 200),
      // ),
      // navBarStyle: NavBarStyle.style1,
      // hideNavigationBar: showNav,
    ));
  }
}
