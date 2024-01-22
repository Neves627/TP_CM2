import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Team {
  String name;

  Team({required this.name});

  @override
  String toString() {
    return 'Team(name: $name)';
  }


  factory Team.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return Team(
      name: data['name'] ?? '',
    );
  }
}

//Recebe todas as equipas
Future<List<Team>> getAllTeams() async {
  List<Team> teams = [];

  try {
    QuerySnapshot teamQuerySnapshot =
        await FirebaseFirestore.instance.collection('Teams').get();

    teams = teamQuerySnapshot.docs.map((teamDoc) {
      Map<String, dynamic> data = teamDoc.data() as Map<String, dynamic>;
      print('Data for document ${teamDoc.id}: $data');

      if (data.containsKey('nome')) {
        String name = data['nome'];
        print('Team name: $name');
        return Team(name: name);
      } else {
        print('Warning: Document ${teamDoc.id} does not have a "nome" field.');
        return Team(name: 'Unknown');
      }
    }).toList();

    return teams;
  } catch (e) {
    print('Error fetching teams data: $e');
    return [];
  }
}
void printTeams() async {
  List<Team> teams = await getAllTeams();
  print(teams);
}

//Cria uma equipa
Future<void> createTeam(String teamName) async {
  try {
 
    Team newTeam = Team(name: teamName);


    await FirebaseFirestore.instance.collection('Teams').doc().set({
      'nome': newTeam.name,
    });

    print('Equipa criada com sucesso!');
  } catch (e) {
    print('Erro ao criar a equipa: $e');
  }
}

//Apaga um user na bd
Future<void> deleteUserInDatabase(String userId) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.delete();
      print('User deleted from the database');
    } else {
      print('User with id $userId not found in the database');
    }
  } catch (e) {
    print('Error deleting user from the database: $e');
  }
}

// Remove o user da autenticação
Future<void> deleteUserAuthentication(String userEmail) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email == userEmail) {
      await user.delete();
    } else {
      print('Error: Current user not authenticated or email mismatch.');
    }
  } catch (e) {
    print('Error deleting user authentication account: $e');
  }
}

//Remove a autenticação por email
Future<void> removeAuthenticationByEmail(String userEmail) async {
  try {
    List<String> methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(userEmail);

    if (methods.isNotEmpty) {
      UserCredential authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail,
        password: '123123', 
      );

      // Get the user object
      User? user = authResult.user;

      if (user != null) {
        await user.delete();
        print('Authentication removed for user with email: $userEmail');
      } else {
        print('Error: User with email $userEmail not found.');
      }
    } else {
      print('Error: User with email $userEmail not found.');
    }
  } catch (e) {
    print('Error removing user authentication by email: $e');
  }
}
