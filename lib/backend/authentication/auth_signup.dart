import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seaaegis/model/user_details.dart';

class AuthSignUp {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserDetails> getUserDetails() async {
    User currentUser = auth.currentUser!;
    DocumentSnapshot snap = await firestore
        .collection(_getCollectionName())
        .doc(currentUser.uid)
        .get();
    return UserDetails.fromSnapshot(snap);
  }

  Future<String> signup({
    required String email,
    required String password,
    required String username,
    required bool isuser, // Updated variable name
  }) async {
    String res = "some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        // User signup
        UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Adding user to database
        UserDetails userDetails = UserDetails(
          uid: cred.user!.uid,
          username: username,
          email: email,
        );
        await firestore
            .collection(
                isuser ? 'Users' : 'Safeguards') // Updated collection name
            .doc(cred.user!.uid)
            .set(userDetails.toJson());
        res = "success";
      } else {
        res = "please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        res = 'The account already exists for that email.';
      } else if (e.code == "invalid-email") {
        res = "Email is badly formatted";
      } else {
        res = e.message.toString();
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Helper method to get collection name based on the user type
  String _getCollectionName() {
    User currentUser = auth.currentUser!;
    // Assuming you have a field in your UserDetails to determine the type
    return currentUser.displayName != null &&
            currentUser.displayName!.contains('Safeguard')
        ? 'Safeguards'
        : 'Users';
  }
}
