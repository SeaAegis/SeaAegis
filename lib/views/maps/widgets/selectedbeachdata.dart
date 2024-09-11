import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:seaaegis/views/maps/nearbyplaceslistscreen.dart';

class SelectedBeachData extends StatefulWidget {
  final LatLng beachcoor;
  const SelectedBeachData({super.key, required this.beachcoor});

  @override
  State<SelectedBeachData> createState() => _SelectedBeachDataState();
}

class _SelectedBeachDataState extends State<SelectedBeachData> {
  String response = "";
  String beachname = "";
  String beachlocation = "";
  bool isfav = false;
  List<String> fsqid = [];
  List<String> icons = [];
  List<String> isopen = [];
  List<String> photoslinks = [];
  List<String> reviewscontent = [];
  List<String> placename = [];

  Future<void> fetchrequireddata(double latitude, double longitude) async {
    final String apiUrl =
        'https://api.foursquare.com/v3/places/search?ll=$latitude,$longitude';
    const String authToken = 'fsq3OBnmL2pkxUCd5b9n8+HYJB5oFAVJikfii+RpnuOxw4o=';

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
          isopen.clear();

          int resultsLength = data["results"].length;
          // print("result length : $resultsLength");
          for (int i = 0; i < resultsLength; i++) {
            var place = data["results"][i];
            fsqid.add(place["fsq_id"] ?? "Unknown ID");
            isopen.add(place["closed_bucket"] ?? "Unknown");
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
    const String authToken = 'fsq3OBnmL2pkxUCd5b9n8+HYJB5oFAVJikfii+RpnuOxw4o=';

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
    const String authToken = 'fsq3OBnmL2pkxUCd5b9n8+HYJB5oFAVJikfii+RpnuOxw4o=';

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isopen.isNotEmpty
                                  ? isopen[0]
                                  : "No status available",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue),
                            ),
                            const SizedBox(
                              width: 100,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return NearbyPlacesList(
                                      placename: placename,
                                      placeicons: icons,
                                      fsqid: fsqid,
                                    );
                                  }));
                                },
                                child: const Text(
                                  "Near By Places",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue),
                                ))
                          ],
                        ),
                        const SizedBox(height: 15),
                        photoslinks.isNotEmpty
                            ? SizedBox(
                                height: 300,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: photoslinks.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 240,
                                        margin: const EdgeInsets.symmetric(
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
                                            photoslinks[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const Text("No photos available"),
                        const SizedBox(height: 20),
                        const Text(
                          "Reviews",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Colors.red),
                        ),
                        // const SizedBox(height: 10),
                        reviewscontent.isNotEmpty
                            //     ? SizedBox(
                            //         height: 300,
                            //         child: ListView.builder(
                            //         scrollDirection: Axis.vertical,
                            //         itemCount: reviewscontent.length,
                            //         itemBuilder: (context, index) {
                            //           return Container(
                            //             margin: const EdgeInsets.symmetric(vertical: 8),
                            //             padding: const EdgeInsets.all(15),
                            //             decoration: BoxDecoration(
                            //               color: Colors.white,
                            //               borderRadius: BorderRadius.circular(15),
                            //               border: Border.all(
                            //                 color: Colors.grey.shade300,
                            //                 width: 1.0,
                            //               ),
                            //               boxShadow: const [
                            //                  BoxShadow(
                            //                   color: Colors.black12,
                            //                   blurRadius: 6.0,
                            //                   spreadRadius: 2.0,
                            //                   offset: Offset(0, 4),
                            //                 ),
                            //               ],
                            //             ),
                            //             child: Text(
                            //               reviewscontent[index],
                            //               style: const TextStyle(
                            //                 fontSize: 18,
                            //                 fontWeight: FontWeight.w500,
                            //                 color: Colors.black87,
                            //                 height: 1.5,
                            //               ),
                            //               textAlign: TextAlign.justify,
                            //             ),
                            //           );
                            //         },
                            //       )
                            //     )
                            // : const Text("No reviews found"),
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: reviewscontent.map((review) {
                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1.0,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 6.0,
                                          spreadRadius: 2.0,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      review,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  );
                                }).toList(),
                              )
                            : const Text("No reviews found"),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return NearbyPlacesList(
                                    placename: placename,
                                    placeicons: icons,
                                    fsqid: fsqid,
                                  );
                                }));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.blue[400]),
                              ),
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Center(
                                    child: Text(
                                  "Near By Places",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                              )),
                        )
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
