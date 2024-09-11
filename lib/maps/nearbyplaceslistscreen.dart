import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seaaegis/maps/nearbyplacesdatascreen.dart';

class NearbyPlacesList extends StatefulWidget {
  final List<String> placeicons;
  final List<String> fsqid;
  final List<String> placename;

  const NearbyPlacesList({
    super.key,
    required this.placename,
    required this.placeicons,
    required this.fsqid,
  });

  @override
  State<NearbyPlacesList> createState() => _NearbyPlacesListState();
}

class _NearbyPlacesListState extends State<NearbyPlacesList> {

  String response="";

  Future<void> fetchinfo(String fsqid, cee0db84cd4236a59edab63) async {
    final String apiUrl =
        'https://api.foursquare.com/v3/places/$fsqid';
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
        var placeinfo = jsonDecode(response.body);
        print(placeinfo);
        
      }
    } catch (e) {
      setState(() {
        response = 'Error fetching photos: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nearby Places"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.blue[100],
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Popular Attractions near ${widget.placename[0]}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Icon(
                    Icons.location_on,
                    size: 40,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: widget.placeicons.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                      return const SizedBox.shrink(); 
                  }
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return Nearbyplacesdata(fsqid: widget.fsqid[index]);
                        }));
                      },
                      child: Row(
                        children: [
                          Image.network(
                            widget.placeicons[index],
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, size: 100);
                            },
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              widget.placename[index],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
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
