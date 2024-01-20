import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String id;
  String email;
  String nome;
  String lane; 
  int adm;
  int vitorias;
  int derrotas;
  String equipa;
  int njogos;

  User({
    required this.id,
    required this.email,
    required this.nome,
    required this.lane,
    required this.adm,
    required this.vitorias,
    required this.derrotas,
    required this.equipa,
    required this.njogos,

  });


  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

   
    String lane = data['lane'] ?? '';

    return User(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      nome: data['nome'] ?? '',
      lane: lane,
      adm: data['data'] ?? 0,
      vitorias: data['vitorias'] ?? 0,
      derrotas: data['derrotas'] ?? 0,
      equipa: data['equipa'] ?? '',
      njogos: data['njogos'] ?? 0,
    );
  }
}

Future<void> updateUserInCollection(String userId, String newName, String newEmail) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: userId)
        .limit(1) 
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      // Document exists, proceed with the update
      QueryDocumentSnapshot userDocSnapshot = userQuerySnapshot.docs.first;

      // Update Firebase Authentication email
      await updateFirebaseAuthEmail(userId, newEmail);

      // Update Firestore document
      await users.doc(userDocSnapshot.id).update({
        'nome': newName,
        'email': newEmail,
      });

      print("Alterado com sucesso");
    } else {
      // Document does not exist
      print('User with ID $userId not found in Firestore.');
    }
  } catch (e) {
    print('Error updating user data: $e');
  }
}

Future<void> updateFirebaseAuthEmail(String userId, String newEmail) async {
  try {
    firebase_auth.User? currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

    if (currentUser != null && currentUser.uid == userId) {
      await currentUser.updateEmail(newEmail);
      print("Firebase Authentication: Email updated successfully");
    } else {
      print("Firebase Authentication: User not found or UID does not match");
    }
  } catch (e) {
    print("Error updating Firebase Authentication email: $e");
  }
}

Future<User?> getUserData(String userId) async {
  try {
    print('Fetching user data for userId: $userId');
    
    // Firestore query to get user data
    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: userId)
        .limit(1) // Limit to 1 document since user ID is expected to be unique
        .get();
    
    // Check if any documents were found
    if (userQuerySnapshot.docs.isNotEmpty) {
      // Take the first document in the query result
      QueryDocumentSnapshot userDocumentSnapshot = userQuerySnapshot.docs.first;
      
      // Call the factory method to create a User object from the document snapshot
      User user = User.fromSnapshot(userDocumentSnapshot);
      
      print('User data retrieved: $user');
      return user;
    } else {
      print('User with ID $userId not found in Firestore.');
      return null;
    }
  } catch (e) {
    // Print or log the error
    print('Error fetching user data: $e');
    
    // Return null in case of an error
    return null;
  }

  
}

Future<void> updateUserTeam(String userId, String newTeam) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: userId)
        .limit(1)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      // Document exists, proceed with the update
      QueryDocumentSnapshot userDocSnapshot = userQuerySnapshot.docs.first;
      await users.doc(userDocSnapshot.id).update({
        'equipa': newTeam,
      });

      print("Team updated successfully");
    } else {
      // Document does not exist
      print('User with ID $userId not found in Firestore.');
    }
  } catch (e) {
    print('Error updating user team: $e');
  }
}

Future<void> updateUserLane(String userId, String newLane) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: userId)
        .limit(1)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      // Document exists, proceed with the update
      QueryDocumentSnapshot userDocSnapshot = userQuerySnapshot.docs.first;
      await users.doc(userDocSnapshot.id).update({
        'lane': newLane,
      });

      print("Lane updated successfully");
    } else {
      // Document does not exist
      print('User with ID $userId not found in Firestore.');
    }
  } catch (e) {
    print('Error updating user lane: $e');
  }
}

Future<int?> getadm(String userId) async {
  try {
    print('Fetching adm for userId: $userId');

    // Firestore query to get user data
    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: userId)
        .limit(1)
        .get();

    // Check if any documents were found
    if (userQuerySnapshot.docs.isNotEmpty) {
      // Take the first document in the query result
      QueryDocumentSnapshot userDocumentSnapshot = userQuerySnapshot.docs.first;

      // Directly return the adm field as an int
      return userDocumentSnapshot['adm'] as int?;
    } else {
      print('User with ID $userId not found in Firestore.');
      return null;
    }
  } catch (e) {
    // Print or log the error
    print('Error fetching adm data: $e');
    return null;
  }
}
Future<void> removeTeam(String teamName) async {
  try {
    // Remove the team from the "Teams" collection
    await FirebaseFirestore.instance.collection('Teams').where('nome', isEqualTo: teamName).get().then((querySnapshot) {
      querySnapshot.docs.forEach((teamDoc) async {
        // Delete the team document
        await teamDoc.reference.delete();
        print('Team $teamName removed from the "Teams" collection');
      });
    });

    // Update the "equipa" field in the "Users" collection for users with the removed team
    await FirebaseFirestore.instance.collection('Users').where('equipa', isEqualTo: teamName).get().then((querySnapshot) {
      querySnapshot.docs.forEach((userDoc) async {
        // Update the 'equipa' field to an empty string
        await userDoc.reference.update({'equipa': ''});
        print('User ${userDoc.id} updated: equipa set to empty');
      });
    });

    print('Team removal process completed successfully.');
  } catch (e) {
    print('Error removing team: $e');
  }
}

Future<List<String>> getAllUserNames() async {
  try {
    // Firestore query to get all user data
    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance.collection('Users').get();

    // Check if any documents were found
    if (userQuerySnapshot.docs.isNotEmpty) {
      // Map the query result to a list of user names
      List<String> userNames = userQuerySnapshot.docs.map((userDoc) {
        return userDoc['nome'] as String? ?? ''; // Using 'nome' as the field, update it if needed
      }).toList();

      return userNames;
    } else {
      print('No users found in Firestore.');
      return [];
    }
  } catch (e) {
    // Print or log the error
    print('Error fetching user names: $e');
    return [];
  }
}

Future<List<User>> getAllUsers() async {
  try {
    // Firestore query to get all users
    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance.collection('Users').get();

    // Map each document snapshot to a User object and return a list of users
    List<User> users = userQuerySnapshot.docs.map((doc) => User.fromSnapshot(doc)).toList();

    return users; // Return the list of users
  } catch (e) {
    print('Error fetching all users: $e');
    return []; // Return an empty list in case of an error
  }
}

Future<List<String>> getAllEmails() async {
  try {
    // Firestore query to get all users
    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance.collection('Users').get();

    // Map each document snapshot to an email string and return a list of emails
    List<String> emails = userQuerySnapshot.docs.map((doc) => doc['email'] as String? ?? '').toList();

    return emails; // Return the list of emails
  } catch (e) {
    print('Error fetching all emails: $e');
    return []; // Return an empty list in case of an error
  }
}


