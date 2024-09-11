import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Nearbyplacesdata extends StatefulWidget {
  final String fsqid;
  const Nearbyplacesdata({
    super.key,
    required this.fsqid,
  });

  @override
  _NearbyplacesdataState createState() => _NearbyplacesdataState();
}

class _NearbyplacesdataState extends State<Nearbyplacesdata> {
  String name = "";
  String location = "";
  String placeicon = "";
  String err = "";
  List<String> photoslinks = [];
  List<String> reviewscontent = [];
  bool isLoading = false;
  Future<void> fetchplacedetails(String fsqid) async {
    setState(() {
      isLoading = true;
    });
    final String apiUrl = 'https://api.foursquare.com/v3/places/$fsqid';
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
        final data = jsonDecode(response.body);
        // print(data["categories"][0]["icon"]);
        setState(() {
          location = data["location"]["formatted_address"];
          name = data["name"];
          placeicon =
              "${data["categories"][0]["icon"]["prefix"]}bg_64${data["categories"][0]["icon"]["suffix"]}";
        });
        // print("Location : $location");
        // print("Name : $name");
        // print('Icon : $placeicon');
      } else {
        setState(() {
          err = 'Failed to load details. Status code: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        err = 'Error fetching details: $error';
      });
    }
  }

  Future<void> fetchplacephotos(String fsqid) async {
    final String apiUrl = 'https://api.foursquare.com/v3/places/$fsqid/photos';
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
        // print(photoData.length);
        // print(photoslinks.toString());
      } else {
        setState(() {
          photoslinks = [
            'Failed to load photos. Status code: ${response.statusCode}'
          ];
        });
      }
    } catch (e) {
      setState(() {
        photoslinks = ['Error fetching photos: $e'];
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
          // print(reviewscontent[i]);
        }

        setState(() {
          reviewscontent = reviewscontent;
          isLoading = false;
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
    loadData();
    super.initState();
  }

  void loadData() {
    fetchplacedetails(widget.fsqid);
    fetchplacephotos(widget.fsqid);
    fetchreviews(widget.fsqid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Places Data'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 45),
                        )),
                        const SizedBox(width: 10),
                        Image.network(
                          placeicon,
                          height: 55,
                          width: 55,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3.0,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.black45.withOpacity(0.5),
                                          blurRadius: 4.0,
                                          spreadRadius: 2.0,
                                          offset: const Offset(2, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
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
                    const SizedBox(height: 30),
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Reviews",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Colors.red),
                        )),
                    // const SizedBox(height: 10),
                    reviewscontent.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: reviewscontent.map((review) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
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
                  ],
                ),
              ),
            ),
    );
  }
}
