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
  HomeScreen({super.key});
  List<Beach> beaches = [
    Beach(image: 'assets/images/2633.jpg', name: 'Beach 1'),
    Beach(image: 'assets/images/5352.jpg', name: 'Beach 2'),
    Beach(image: 'assets/images/6728.jpg', name: 'Beach 3'),
    Beach(image: 'assets/images/2151794936.jpg', name: 'Beach 4'),
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: const BasicAppBar(
          isBack: false,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Hi, Vishnu!',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SearchTextField(
                  hintText: 'Search location...',
                ),
                const SizedBox(
                  height: 14,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade50,
                  ),
                  child: const Center(
                    child: Text(
                      'Current Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  'Populor Beaches',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: beaches.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 140,
                      height: 160,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(beaches[index].image))),
                      child: Stack(
                        children: [
                          Positioned(
                              right: 10,
                              top: 10,
                              child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade100,
                                  child: const Icon(
                                    Icons.favorite_border,
                                    color: Colors.black,
                                    size: 28,
                                  ))),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                beaches[index].name,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ))
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
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
      HomeScreen(),
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
        inactiveIcon: const Icon(Icons.notifications),
        icon: const Icon(Icons.notifications_outlined),
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

        navBarHeight: 60,
        // padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),

        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
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
        navBarStyle: NavBarStyle.style1,
        // hideNavigationBar: showNav,
      ),
    );
  }
}

class Beach {
  final String image;
  final String name;

  Beach({required this.image, required this.name});
}
