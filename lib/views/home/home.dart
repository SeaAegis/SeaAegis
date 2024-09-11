import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:seaaegis/model/beach.dart';
import 'package:seaaegis/providers/app_theme.dart';
import 'package:seaaegis/views/alerts/alert_message.dart';
import 'package:seaaegis/views/beach_data/beach_stats.dart';
import 'package:seaaegis/views/favorites/favorite.dart';
import 'package:seaaegis/widgets/basic_app_bar.dart';
import 'package:seaaegis/views/home/widgets/search_text_field.dart';
import 'package:seaaegis/testApi/tester1.dart'; // For fetchBeachConditions

class HomeScreen extends StatefulWidget {
  final Function()? onBack;

  const HomeScreen({super.key, this.onBack});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    print('function started');
    List<BeachConditions> beachConditions =
        await fetchBeachConditions(beach.lat, beach.lon);

    if (beachConditions.isNotEmpty) {
      // Pass the fetched conditions to BeachStats Page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BeachStats(
            beachDetails: BeachDetails(
                latLng: LatLng(beach.lat, beach.lon),
                placeClass: 'placeClass',
                type: 'beach',
                addressType: 'village',
                name: beach.name,
                district: 'district',
                state: 'state',
                pincode: 'pincode',
                country: 'India'),
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
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    size: 32,
                  ),
                  onPressed: () {
                    Scaffold.of(context)
                        .openEndDrawer(); // Opens the end drawer
                  },
                );
              },
            ),
            const SizedBox(width: 24),
          ],
          // Automatically provides the hamburger menu icon to open the drawer
        ),
        endDrawer: NotificationsDrawer(), // The side drawer
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
                    TextButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: const Text('See More')),
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
                      onDoubleTap: () =>
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
                                child: IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: beaches[index].liked
                                        ? Colors.red
                                        : Colors
                                            .black45, // Use the liked property
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      beaches[index].liked = !beaches[index]
                                          .liked; // Toggle the liked status
                                    });
                                  },
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
      const HomeScreen(), // Home Screen
      const Favorites(), // Favorites Screen
      const AlertMessage(), // Alerts Screen
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
  bool liked;
  Beach(
      {required this.name,
      required this.lat,
      required this.lon,
      required this.image,
      this.liked = false});
}

class NotificationsDrawer extends StatelessWidget {
  // Dummy data for notifications
  final List<Map<String, String>> beachNotifications = [
    {
      'beach': 'Goa',
      'status': 'Dangerous to visit',
      'time': "14:30",
    },
    {
      'beach': 'Bapatla',
      'status': 'Dangerous to visit',
      'time': "16:30",
    },
    {
      'beach': 'Perupalem',
      'status': 'Dangerous to visit',
      'time': "15:30",
    },
    {
      'beach': 'Rushikonda Beach',
      'status': 'Safe to visit',
      'time': "10:30",
    },
  ];

  NotificationsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: beachNotifications.length,
                itemBuilder: (context, index) {
                  final notification = beachNotifications[index];
                  return ListTile(
                    leading: Icon(
                      notification['status'] == 'Safe to visit'
                          ? Icons.check_circle_outline
                          : Icons.warning_amber_outlined,
                      color: notification['status'] == 'Safe to visit'
                          ? Colors.green
                          : Colors.red,
                    ),
                    title: Text(
                      notification['beach']!,
                    ),
                    subtitle: Text(
                        "${notification['status']!} at ${notification['time']!}",
                        style: TextStyle(
                          color: notification['status'] == 'Safe to visit'
                              ? Colors.green
                              : Colors.red,
                        )),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
