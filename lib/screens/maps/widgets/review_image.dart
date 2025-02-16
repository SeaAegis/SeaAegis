import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:seaaegis/providers/user_provider.dart';

class ImageReviewScreen extends StatelessWidget {
  final Uint8List? selectedImage;
  final UserProvider provider;
  final LatLng latLng;
  const ImageReviewScreen(
      {super.key,
      required this.selectedImage,
      required this.provider,
      required this.latLng});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Image'),
      ),
      body: Column(
        children: [
          Expanded(
            child: selectedImage != null
                ? Image.memory(
                    selectedImage!,
                    fit: BoxFit.cover,
                  )
                : const Center(
                    child: Text('No image selected.'),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement your alert functionality here
                  },
                  icon: const Icon(Icons.warning),
                  label: const Text('Alert'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Implement your review/edit functionality here
                    if (provider.uploadImage!.isNotEmpty) {
                      await provider.generateuploadUrl();
                      if (provider.uploadUrl != null) {
                        await provider.addBeachReviewPhotos(
                            '${latLng.latitude}${latLng.longitude}');
                      }
                    }
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.upload),
                  label: const Text('upload'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
