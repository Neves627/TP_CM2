import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();


Future<void> signInWithEmailAndPassword({
  required String email,
  required String password,
}) async{
  await _firebaseAuth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    void Function(bool emailAlreadyInUse)? onEmailAlreadyInUse,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use' && onEmailAlreadyInUse != null) {
        onEmailAlreadyInUse(true);
      } else {
        print("Firebase Authentication Error: $e");
        throw e;
      }
    }
  }

  static Future<String?> getLoggedInUserId() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      return currentUser?.uid;
    } catch (e) {
      print('Error getting logged-in user ID: $e');
      return null;
    }
  }

  Future<String?> checkUidInCollection() async {
  try {
    // Get the current authenticated user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Reference to the Firestore collection
      CollectionReference users = FirebaseFirestore.instance.collection('Users');

      // Query the collection for the user with the matching UID
      QuerySnapshot querySnapshot = await users.where('id', isEqualTo: user.uid).get();

      // Iterate through the documents in the QuerySnapshot
      querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
      });

      if (querySnapshot.docs.isNotEmpty) {
        // User with matching UID found in the collection
        print('User with UID ${user.uid} found in the collection.');
        return user.uid; // Return the user ID
      } else {
        // User with matching UID not found in the collection
        print('User with UID ${user.uid} not found in the collection.');
        return null; // or return an empty string if you prefer
      }
    } else {
      // No user is currently authenticated
      print('No user is currently authenticated.');
      return null;
    }
  } catch (e) {
    print('Error checking UID in collection: $e');
    return null;
  }
}
Future<List<String>> fetchStringList(String documentId) async {
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('Users')
      .doc(documentId)
      .get();

  if (documentSnapshot.exists) {
    // Assuming the field name is 'yourListField'
    List<dynamic>? stringList = documentSnapshot['yourListField'];

    if (stringList != null && stringList is List<String>) {
      return stringList;
    } else {
      throw Exception('Invalid data structure in Firestore.');
    }
  } else {
    throw Exception('Document does not exist.');
  }
}

}


