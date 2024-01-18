import 'package:cloud_firestore/cloud_firestore.dart';

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