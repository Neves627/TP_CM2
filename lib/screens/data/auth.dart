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
    // Create a user in Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Access the UID of the newly created user
    String uid = userCredential.user?.uid ?? '';

    // Add a new document to Firestore
    await FirebaseFirestore.instance.collection('Users').doc(uid).set({
      'email': email,
      'id': uid,
      'name': '',
      'team': '',
      'adm': 0,
      'vitorias': 0,
      'derrotas': 0,
      'lane': '',
      'nJogos': 0,
    });

  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use' && onEmailAlreadyInUse != null) {
      onEmailAlreadyInUse(true);
    } else {
      print("Firebase Authentication Error: $e");
      throw e;
    }
  } catch (e) {
    print("Error creating user and adding document to Firestore: $e");
    throw e;
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


