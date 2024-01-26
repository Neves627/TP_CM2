import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

//Da update aos dados na base de dados
Future<void> updateUserInCollection(String userId, String newName, String newEmail, BuildContext context) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    QuerySnapshot userQuerySnapshot = await users.where('id', isEqualTo: userId).limit(1).get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot userDocSnapshot = userQuerySnapshot.docs.first;

      // Retrieve current user's email
      String currentUserEmail = userDocSnapshot['email'];

      // Update name regardless of email change
      await users.doc(userDocSnapshot.id).update({
        'nome': newName,
      });

      if (currentUserEmail != newEmail) {
        List<String> methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(newEmail);

        QuerySnapshot emailQuerySnapshot = await users.where('email', isEqualTo: newEmail).limit(1).get();

        if (methods.isNotEmpty || emailQuerySnapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('O email já está em uso.'),
            ),
          );
        } else {
          await updateFirebaseAuthEmail(userId, newEmail);

          await users.doc(userDocSnapshot.id).update({
            'email': newEmail,
          });

          print("Alterado com sucesso");
        }
      } else {
        print("O novo email é o mesmo que o atual.");
      }
    } else {
      print('Usuário com ID $userId não encontrado no Firestore.');
    }
  } catch (e) {
    print('Erro ao atualizar os dados do usuário: $e');
  }
}


//da update ao e-mail da autenticação
Future<void> updateFirebaseAuthEmail(String userId, String newEmail) async {
  try {
    firebase_auth.User? currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

    if (currentUser != null && currentUser.uid == userId) {
      
      List<String> methods = await firebase_auth.FirebaseAuth.instance.fetchSignInMethodsForEmail(newEmail);

      if (methods.isNotEmpty) {
        print("The new email is already in use.");
        
      } else {
        
        await currentUser.verifyBeforeUpdateEmail(newEmail);
        print("Firebase Authentication: Email updated successfully");
      }
    } else {
      print("Firebase Authentication: User not found or UID does not match");
    }
  } catch (e) {
    print("Error updating Firebase Authentication email: $e");
  }
}

//Recolhe a data do utilizador
Future<User?> getUserData(String userId) async {
  try {
    print('Fetching user data for userId: $userId');
    
   
    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: userId)
        .limit(1) 
        .get();
    
    
    if (userQuerySnapshot.docs.isNotEmpty) {
     
      QueryDocumentSnapshot userDocumentSnapshot = userQuerySnapshot.docs.first;
      
     
      User user = User.fromSnapshot(userDocumentSnapshot);
      
      print('User data retrieved: $user');
      return user;
    } else {
      print('User with ID $userId not found in Firestore.');
      return null;
    }
  } catch (e) {
   
    print('Error fetching user data: $e');
    
    
    return null;
  }

  
}
//Da update á equipa do utilizador na bd
Future<void> updateUserTeam(String userId, String newTeam) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: userId)
        .limit(1)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
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

//Update da lane do user na bd
Future<void> updateUserLane(String userId, String newLane) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: userId)
        .limit(1)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot userDocSnapshot = userQuerySnapshot.docs.first;
      await users.doc(userDocSnapshot.id).update({
        'lane': newLane,
      });

      print("Lane updated successfully");
    } else {
      print('User with ID $userId not found in Firestore.');
    }
  } catch (e) {
    print('Error updating user lane: $e');
  }
}

//Receve o valor do adm do user logado
Future<int?> getadm(String userId) async {
  try {
    print('Fetching adm for userId: $userId');

    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: userId)
        .limit(1)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot userDocumentSnapshot = userQuerySnapshot.docs.first;

      return userDocumentSnapshot['adm'] as int?;
    } else {
      print('User with ID $userId not found in Firestore.');
      return null;
    }
  } catch (e) {
    print('Error fetching adm data: $e');
    return null;
  }
}

//Remove a equipa da bd e do utilizador e deixa com ''
Future<void> removeTeam(String teamName) async {
  try {
    await FirebaseFirestore.instance.collection('Teams').where('nome', isEqualTo: teamName).get().then((querySnapshot) {
      querySnapshot.docs.forEach((teamDoc) async {
        await teamDoc.reference.delete();
        print('Team $teamName removed from the "Teams" collection');
      });
    });

    await FirebaseFirestore.instance.collection('Users').where('equipa', isEqualTo: teamName).get().then((querySnapshot) {
      querySnapshot.docs.forEach((userDoc) async {
        await userDoc.reference.update({'equipa': ''});
        print('User ${userDoc.id} updated: equipa set to empty');
      });
    });

    print('Team removal process completed successfully.');
  } catch (e) {
    print('Error removing team: $e');
  }
}

//Recebe todos os nomes dos utilizadores
Future<List<String>> getAllUserNames() async {
  try {
    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance.collection('Users').get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      List<String> userNames = userQuerySnapshot.docs.map((userDoc) {
        return userDoc['nome'] as String? ?? ''; 
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

//Recebe todos os users
Future<List<User>> getAllUsers() async {
  try {
    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance.collection('Users').get();

    List<User> users = userQuerySnapshot.docs.map((doc) => User.fromSnapshot(doc)).toList();

    return users;
  } catch (e) {
    print('Error fetching all users: $e');
    return []; 
  }
}

//Recebe todos os emails
Future<List<String>> getAllEmails() async {
  try {
    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance.collection('Users').get();

    List<String> emails = userQuerySnapshot.docs.map((doc) => doc['email'] as String? ?? '').toList();

    return emails; 
  } catch (e) {
    print('Error fetching all emails: $e');
    return [];
  }
}


