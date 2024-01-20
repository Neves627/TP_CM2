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

Future<List<Team>> getAllTeams() async {
  List<Team> teams = [];

  try {
    QuerySnapshot teamQuerySnapshot =
        await FirebaseFirestore.instance.collection('Teams').get();

    teams = teamQuerySnapshot.docs.map((teamDoc) {
      Map<String, dynamic> data = teamDoc.data() as Map<String, dynamic>;
      print('Data for document ${teamDoc.id}: $data');

      // Check if 'nome' field exists in the document data
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

Future<void> createTeam(String teamName) async {
  try {
    // Create a new team object
    Team newTeam = Team(name: teamName);

    // Add the team to the "Teams" collection with a random document ID
    await FirebaseFirestore.instance.collection('Teams').doc().set({
      'nome': newTeam.name,
    });

    print('Equipa criada com sucesso!');
  } catch (e) {
    print('Erro ao criar a equipa: $e');
  }
}

Future<void> deleteUserInDatabase(String userId) async {
  try {
    // Query the Firestore collection to find the document with the matching 'id'
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: userId)
        .get();

    // Check if any matching documents were found
    if (querySnapshot.docs.isNotEmpty) {
      // Delete the first matching document (assuming there's only one)
      await querySnapshot.docs.first.reference.delete();
      print('User deleted from the database');
    } else {
      print('User with id $userId not found in the database');
    }
  } catch (e) {
    print('Error deleting user from the database: $e');
  }
}

// Function to delete user authentication account
Future<void> deleteUserAuthentication(String userEmail) async {
  try {
    // Get the current authenticated user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email == userEmail) {
      // User is authenticated, delete the account
      await user.delete();
    } else {
      print('Error: Current user not authenticated or email mismatch.');
    }
  } catch (e) {
    print('Error deleting user authentication account: $e');
  }
}

Future<void> removeAuthenticationByEmail(String userEmail) async {
  try {
    print("asndakjsdnakjsdnjaksndkja $userEmail");

    // Check if there are sign-in methods for the email
    List<String> methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(userEmail);

    if (methods.isNotEmpty) {
      // Sign in with the email (using a dummy password)
      UserCredential authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail,
        password: '123123', // Provide a valid password
      );

      // Get the user object
      User? user = authResult.user;

      if (user != null) {
        // User with specified email found, delete the account
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
