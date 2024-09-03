import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seaaegis/model/user_details.dart';

class AuthSignUp {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserDetails> getUserDetails() async {
    User currentuser = auth.currentUser!;
    DocumentSnapshot snap =
        await firestore.collection('Users').doc(currentuser.uid).get();
    // print(snap.data());
    return UserDetails.fromSnapshot(snap);
  }

  Future<String> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        //user signup
        UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        //adding user to database
        UserDetails userDetails = UserDetails(
            uid: cred.user!.uid,
            username: username,
            email: email,
          );
        await firestore
            .collection('Users')
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
        res = "Email is Badly Formated";
      } else {
        res = e.message.toString();
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}