import 'package:flutter/material.dart';
import 'package:seaaegis/maps/beach_data.dart';

class BeachDetailsPage extends StatefulWidget {
  final String beachName;

  BeachDetailsPage({required this.beachName});

  @override
  _BeachDetailsPageState createState() => _BeachDetailsPageState();
}

class _BeachDetailsPageState extends State<BeachDetailsPage> {
  Map<String, dynamic>? beachDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBeachDetails(widget.beachName).then((details) {
      setState(() {
        beachDetails = details;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Beach Details')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : beachDetails == null
              ? Center(child: Text('No details available'))
              : ListView(
                  padding: EdgeInsets.all(16.0),
                  children: [
                    if (beachDetails!['photos'] != null)
                      ...beachDetails!['photos'].map((photo) {
                        return Image.network(photo['url']);
                      }).toList(),
                    Text(
                      beachDetails!['description'] ??
                          'No description available',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
    );
  }
}
