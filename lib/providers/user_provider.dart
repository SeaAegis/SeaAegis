import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seaaegis/backend/storage/firebase_storage.dart';
import 'package:seaaegis/services/const/image_picker_f.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _deviceToken = '';
  String get deviceToken => _deviceToken;
  void setDeviceToken(String token) {
    _deviceToken = token;
    notifyListeners();
  }

  Uint8List? _uploadImage;
  Uint8List? get uploadImage => _uploadImage;

  void selectImage(ImageSource source) async {
    XFile? image = await pickImage(source);
    if (image != null) {
      _uploadImage = await image.readAsBytes();
    } else {
      _uploadImage = null;
    }
    // if (image.isNotEmpty) {
    //   generateuploadUrl();
    // }
    notifyListeners();
  }

  String? _uploadUrl;
  String? get uploadUrl => _uploadUrl;

  Future<void> generateuploadUrl() async {
    try {
      _uploadUrl = await StorageMethods.uploadImageToStorage(
        childName: 'media',
        file: uploadImage!,
      );
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<String> addBeachReviewPhotos(String id) async {
    String res = '';
    try {
      await _firestore
          .collection('Beach Data')
          .doc(id)
          .collection('photos')
          .add({'image': uploadUrl});
      res = 'done';
    } catch (e) {
      res = e.toString();
      print(e.toString());
    }
    notifyListeners();
    return res;
  }

  Future<String> addBeachReviewText(String id, String review) async {
    String res = '';
    try {
      await _firestore
          .collection('Beach Data')
          .doc(id)
          .collection('reviews')
          .add({'text': review});
      res = 'done';
    } catch (e) {
      res = e.toString();
      print(e.toString());
    }
    notifyListeners();
    return res;
  }
}
