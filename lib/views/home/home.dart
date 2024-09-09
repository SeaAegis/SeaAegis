import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:seaaegis/providers/app_theme.dart';
import 'package:seaaegis/views/alerts/alert_message.dart';
import 'package:seaaegis/views/beach_data/beach_stats.dart';
import 'package:seaaegis/views/favorites/favorite.dart';
import 'package:seaaegis/widgets/basic_app_bar.dart';
import 'package:seaaegis/views/home/widgets/search_text_field.dart';
import 'package:seaaegis/testApi/tester1.dart'; // For fetchBeachConditions

class HomeScreen extends StatelessWidget {
  final Function()? onBack;

  HomeScreen({super.key, this.onBack});

  final List<Beach> beaches = [
    Beach(
      image: 'assets/images/2633.jpg',
      name: 'Goa',
      lat: 15.539930,
      lon: 73.763687,
    ),
    Beach(
      image: 'assets/images/5352.jpg',
      name: 'Bapatla',
      lat: 15.895520,
      lon: 80.467890,
    ),
    Beach(
      image: 'assets/images/6728.jpg',
      name: 'Perupalem',
      lat: 16.414021,
      lon: 81.607384,
    ),
    Beach(
      image: 'assets/images/2151794936.jpg',
      name: 'Rushikonda Beach',
      lat: 17.801910,
      lon: 83.397888,
    ),
  ];

  Future<void> _navigateToBeachStats(BuildContext context, Beach beach) async {
    // Fetch the beach conditions
    List<BeachConditions> beachConditions =
        await fetchBeachConditions(beach.lat, beach.lon);

    if (beachConditions.isNotEmpty) {
      // Pass the fetched conditions to BeachStats Page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BeachStats(
            beachConditions:
                beachConditions[0], // Show the first condition for now
            conditionList: beachConditions, // Pass the entire list if needed
          ),
        ),
      );
    } else {
      // Handle case when no conditions are fetched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('No beach conditions available for ${beach.name}.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: BasicAppBar(
          isBack: false,
          title: const Text(
            'SeaAegis',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(size: 32, Icons.notifications_outlined)),
            const SizedBox(width: 24),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Hi, Vishnu!',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                const SizedBox(height: 10),
                const SearchTextField(
                  hintText: 'Search location...',
                ),
                const SizedBox(height: 14),
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
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Popular Beaches',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text('See More')),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: beaches.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () =>
                          _navigateToBeachStats(context, beaches[index]),
                      child: Container(
                        width: 140,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(beaches[index].image),
                          ),
                        ),
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
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                beaches[index].name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
  bool showNav = true;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(), // This is the updated HomeScreen
      const Favorites(),
      const AlertMessage(),
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
        icon: const Icon(Icons.warning),
        title: "Alerts",
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        resizeToAvoidBottomInset: true,
        navBarHeight: 60,
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
        navBarStyle: NavBarStyle.style1,
        isVisible: showNav,
      ),
    );
  }
}

class Beach {
  final String image;
  final String name;
  final double lat;
  final double lon;

  Beach({
    required this.lat,
    required this.lon,
    required this.image,
    required this.name,
  });
}
