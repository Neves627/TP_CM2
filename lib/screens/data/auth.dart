import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

//Dá signin na autenticação
Future<void> signInWithEmailAndPassword({
  required String email,
  required String password,
}) async{
  await _firebaseAuth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

//Cria na autenticação uma conta
Future<void> createUserWithEmailAndPassword({
  required String email,
  required String password,
  void Function(bool emailAlreadyInUse)? onEmailAlreadyInUse,
}) async {
  try {
    
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Access the UID of the newly created user
    String uid = userCredential.user?.uid ?? '';

    // Send email verification
    await sendEmailVerification();

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

//Manda a verificação de conta no e-mail
Future<void> sendEmailVerification() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  } catch (e) {
    print("Error sending email verification: $e");
    throw e;
  }
}

//Ve se o user loggado tem conta na collection
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
   
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
     
      CollectionReference users = FirebaseFirestore.instance.collection('Users');

      
      QuerySnapshot querySnapshot = await users.where('id', isEqualTo: user.uid).get();

      
      querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
      });

      if (querySnapshot.docs.isNotEmpty) {
        
        print('User with UID ${user.uid} found in the collection.');
        return user.uid; 
      } else {
        
        print('User with UID ${user.uid} not found in the collection.');
        return null; 
      }
    } else {

      print('No user is currently authenticated.');
      return null;
    }
  } catch (e) {
    print('Error checking UID in collection: $e');
    return null;
  }
}


}


