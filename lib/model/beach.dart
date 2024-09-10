import 'package:google_maps_flutter/google_maps_flutter.dart';

class BeachDetails {
  final LatLng latLng;
  final String placeClass;
  final String type;

  final String addressType;
  final String name;

  final String district;
  final String state;
  final String pincode;
  final String country;

  BeachDetails({
    required this.latLng,
    required this.placeClass,
    required this.type,
    required this.addressType,
    required this.name,
    required this.district,
    required this.state,
    required this.pincode,
    required this.country,
  });

  factory BeachDetails.fromJson(Map<String, dynamic> json) {
    List<String> locationParts = json['display_name'].split(', ');
    print(locationParts);
    return BeachDetails(
      latLng: LatLng(double.tryParse(json['lat']) ?? 15.539930,
          double.tryParse(json['lon']) ?? 73.763687),
      placeClass: json['class'],
      type: json['type'],
      addressType: json['addresstype'],
      name: json['name'],
      district: locationParts[1],
      state: locationParts[2],
      pincode: locationParts[3],
      country: locationParts[4],
    );
  }
}
