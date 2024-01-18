import 'package:cloud_firestore/cloud_firestore.dart';

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
