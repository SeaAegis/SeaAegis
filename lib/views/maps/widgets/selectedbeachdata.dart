import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:seaaegis/providers/user_provider.dart';
import 'package:seaaegis/services/notification/notification_service.dart';
import 'package:seaaegis/utils/custombuttons.dart';
import 'package:seaaegis/views/maps/nearbyplaceslistscreen.dart';

class SelectedBeachData extends StatefulWidget {
  final LatLng beachcoor;
  final UserProvider userProvider;
  const SelectedBeachData({
    super.key,
    required this.beachcoor,
    required this.userProvider,
  });

  @override
  State<SelectedBeachData> createState() => _SelectedBeachDataState();
}

class _SelectedBeachDataState extends State<SelectedBeachData> {
  String authToken =
      'fsq3OBnmL2pkxUCd5b9n8+HYJB5oFAVJikfii+RpnuOxw4o='; //Using token
  // String authToken = 'fsq3ZhhBHWDd8MnEL+ukzo959s3LqCZZM6puWgzwOXeuTqk='; //New Api key
  String response = "";
  String beachname = "";
  String beachlocation = "";
  String recommendation = "";
  String summary = '';
  bool isfav = false;
  List<String> fsqid = [];
  List<String> icons = [];
  // List<String> isopen = [];
  List<String> photoslinks = [];
  List<String> reviewscontent = [];
  List<String> placename = [];

  Future<void> fetchrequireddata(double latitude, double longitude) async {
    final String apiUrl =
        'https://api.foursquare.com/v3/places/search?ll=$latitude,$longitude';

    try {
      final http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': authToken,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          fsqid.clear();
          icons.clear();
          // isopen.clear();

          int resultsLength = data["results"].length;
          // print("result length : $resultsLength");
          for (int i = 0; i < resultsLength; i++) {
            var place = data["results"][i];
            fsqid.add(place["fsq_id"] ?? "Unknown ID");
            // isopen.add(place["closed_bucket"] ?? "Unknown");
            placename.add(place["name"] ?? "Unknown");

            if (place["categories"].isNotEmpty) {
              var iconData = place["categories"][0]["icon"];
              var iconUrl = "${iconData["prefix"]}bg_64${iconData["suffix"]}";
              icons.add(iconUrl);
            } else {
              icons.add(const Icon(Icons.location_city).toString());
            }

            if (i == 0) {
              beachlocation =
                  place["location"]["formatted_address"] ?? "Unknown Location";
              beachname = placename[0];

              fetchphotos(fsqid.isNotEmpty ? fsqid[0] : "Unknown ID");

              fetchreviews(fsqid.isNotEmpty ? fsqid[0] : "Unknown ID");
            }
          }
        });
      }
    } catch (e) {
      setState(() {
        response = 'Error making GET request: $e';
      });
    }
  }

  Future<void> fetchphotos(String fsqid) async {
    final String apiUrl =
        'https://api.foursquare.com/v3/places/$fsqid/photos?classifications=outdoor';

    try {
      final http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': authToken,
        },
      );

      if (response.statusCode == 200) {
        var photoData = jsonDecode(response.body);
        setState(() {
          photoslinks.clear();
          for (int i = 0; i < photoData.length; i++) {
            photoslinks.add(
                photoData[i]["prefix"] + "original" + photoData[i]["suffix"]);
          }
        });
      }
    } catch (e) {
      setState(() {
        response = 'Error fetching photos: $e';
      });
    }
  }

  Future<void> fetchreviews(String fsqid) async {
    final String apiUrl = 'https://api.foursquare.com/v3/places/$fsqid/tips';

    try {
      final http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': authToken,
        },
      );

      if (response.statusCode == 200) {
        var reviewData = jsonDecode(response.body);

        for (int i = 0; i < reviewData.length; i++) {
          reviewscontent.add(reviewData[i]["text"]);
        }

        setState(() {
          reviewscontent = reviewscontent;
        });
      } else {
        // print('Error fetching reviews: ${response.statusCode}');
        setState(() {
          reviewscontent = ['Error fetching reviews: ${response.statusCode}'];
        });
      }
    } catch (e) {
      // print('Error: $e');
      setState(() {
        reviewscontent = ['Error fetching reviews: $e'];
      });
    }
  }

  Future<void> analyzeReviews(List<String> reviews) async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.0.102:5001/analyze"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'reviews': reviews}),
      );

      if (response.statusCode == 200) {
        // Handle response from Flask
        final data = jsonDecode(response.body);
        print('Analysis Result: $data');
        // Display the result in your app (you can update this to use the result)
        NotificationServices().sendDeviceNotification(
            title: "Review Analysis",
            deviceToken: widget.userProvider.deviceToken,
            body: '${data['recommendation']['recommendation']}');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            title: const Text(
              'Review Analysis',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0, // Larger font size
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Adjusts size based on content
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the left
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Recommendation:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                  Text(
                    '${data['recommendation']['recommendation']}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 15.0),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Summary of the reviews:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                  Text(
                    '${data['summary']}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0), // Button padding
                  backgroundColor: Colors.blueAccent, // Button text color
                ),
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } else {
        print('Failed to analyze reviews: ${response.statusCode}');
      }
    } catch (e) {
      print('Error analyzing reviews: $e');
    }
  }

  @override
  void initState() {
    fetchrequireddata(widget.beachcoor.latitude, widget.beachcoor.longitude);
    // fetchrequireddata(17.715145507633274, 83.32347554842707);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DraggableScrollableSheet(
        initialChildSize: 0.1,
        minChildSize: 0.1,
        maxChildSize: 0.95,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: ListView(
              controller: scrollController,
              children: [
                const Center(
                  child: Icon(
                    Icons.drag_handle_outlined,
                    size: 30,
                    color: Colors.black54,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              beachname,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            Expanded(
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isfav = !isfav;
                                      });
                                      // print("clicked fav ion");
                                    },
                                    icon: Icon(
                                      Icons.favorite,
                                      color: isfav ? Colors.red : Colors.black,
                                      size: 30,
                                    )))
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 30,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Text(
                              beachlocation,
                              style: const TextStyle(fontSize: 20),
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: CustomButtons(
                            textvalue: "Near By Places",
                            nav: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return NearbyPlacesList(
                                  placename: placename,
                                  placeicons: icons,
                                  fsqid: fsqid,
                                );
                              }));
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        photoslinks.isNotEmpty
                            ? SizedBox(
                                height: 300,
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Beach Data')
                                        .doc(
                                            '${widget.beachcoor.latitude}${widget.beachcoor.longitude}')
                                        .collection('photos')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }

                                      if (snapshot.hasError) {
                                        return const Center(
                                            child: Text(
                                                'Error fetching photos from Firebase'));
                                      }

                                      List<String> firebasePhotoUrls = snapshot
                                          .data!.docs
                                          .map((doc) => doc['image'].toString())
                                          .toList();

                                      List<String> allPhotoUrls = [
                                        ...firebasePhotoUrls,
                                        ...photoslinks
                                      ];
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: allPhotoUrls.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: 240,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 3.0,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black45
                                                        .withOpacity(0.5),
                                                    blurRadius: 4.0,
                                                    spreadRadius: 2.0,
                                                    offset: const Offset(2, 3),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: Image.network(
                                                  allPhotoUrls[index],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }),
                              )
                            : const Text("No photos available"),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text(
                              "Reviews",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red),
                            ),
                            const SizedBox(
                              width: 100,
                            ),
                            Center(
                                child: CustomButtons(
                              textvalue: "Review Analysis",
                              nav: () {
                                analyzeReviews(reviewscontent);
                              },
                            )),
                          ],
                        ),
                        const SizedBox(height: 10),
                        recommendation.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Recommendation: $recommendation"),
                                  const SizedBox(height: 10),
                                  Text("Summary: $summary"),
                                ],
                              )
                            : const SizedBox(),
                        reviewscontent.isNotEmpty
                            ? StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('Beach Data')
                                    .doc(
                                        '${widget.beachcoor.latitude}${widget.beachcoor.longitude}')
                                    .collection('reviews')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  if (snapshot.hasError) {
                                    return const Center(
                                        child: Text(
                                            'Error fetching reviews from Firebase'));
                                  }

                                  List<String> firebaseReviews = snapshot
                                      .data!.docs
                                      .map((doc) => doc['text'].toString())
                                      .toList();

                                  List<String> allReviews = [
                                    ...firebaseReviews,
                                    ...reviewscontent
                                  ];

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: allReviews.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1.0,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4.0,
                                              spreadRadius: 2.0,
                                              offset: Offset(2, 3),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          allReviews[index],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                            height: 1.5,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      );
                                    },
                                  );
                                })
                            : const Text("No reviews found"),
                        const SizedBox(
                          height: 20,
                        ),
                      ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
