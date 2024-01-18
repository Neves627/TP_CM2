import 'package:aplicacao/screens/data/teams.dart';
import 'package:aplicacao/screens/data/user.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  UserProfilePage({required this.userId});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<User?> userinfo;

  @override
  void initState() {
    super.initState();
    userinfo = getUser();
  }

  Future<User?> getUser() async{
    User? userData = await getUserData(widget.userId);
    return userData;  

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
        actions: [
          ElevatedButton(
            onPressed: () async {
              // Fetch user data again if needed
              User? updatedUserData = await getUser();
              setState(() {
                userinfo = Future.value(updatedUserData);
              });
              // confirmação do delete;
            },
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: Text('Apagar Conta'),
          ),
          ElevatedButton(
            onPressed: () {
              //showcreateteam;
            },
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child: Text('Criar Equipa'),
          ),
        ],
      ),
      // ... rest of your code
      body: FutureBuilder<User?>(
        future: userinfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text('User not found');
          } else {
            User user = snapshot.data!;
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 28, 28, 28),
                    Color.fromARGB(255, 79, 77, 77),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Informações do utilizador',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text('Nome: ${user.nome}'),
                            Text('Email: ${user.email}'),
                            Text('Nº de jogador: ${user.id}'),
                            SizedBox(height: 10.0),
                            ElevatedButton(
                              onPressed: () {
                                _showEditUserPopup(context, user);
                              },
                              child: Text('Editar Informações'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    // New Container for Player Info
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Informações do jogador',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text('Numero de jogos: ${user.njogos}'),
                            Text('Vitorias: ${user.vitorias}'),
                            Text('Derrotas: ${user.derrotas}'),
                            Text('Lane: ${user.lane}'),
                            Text('Equipa: ${user.equipa}'),
                            const SizedBox(height: 10.0),
                          
                            ElevatedButton(
                              onPressed: () {
                                _showEditOppPopup(context, user, user.id);
                              },
                              child: Text('Editar Informações'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

void _showEditUserPopup(BuildContext context, User user) {
    String inome = user.nome;
    String iemail = user.email;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Informações do Utilizador'),
          
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: user.nome,
                decoration: const InputDecoration(labelText: 'Nome'),
                onChanged: (value) {
                  user.nome = value;
                },
              ),
              TextFormField(
                initialValue: user.email,
                
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  user.email = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
                  onPressed: () async {
                   
                    await updateUserInCollection(user.id, user.nome, user.email);

                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return UserProfilePage(userId: user.id);
                      }),
                    );
                  },
                  child: Text('Salvar'),
                ),
          ],
        );
      },
    );
  }


void _showEditOppPopup(BuildContext context, User user, String userId) async {
  String ilane = user.lane;
  List<Team> teams = await getAllTeams(); // Fetch teams

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Editar Informações do Utilizador no Opportunity'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Lane: ${user.lane}'),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'Top', child: Text('Top')),
                      const PopupMenuItem(value: 'Jungle', child: Text('Jungle')),
                      const PopupMenuItem(value: 'Mid', child: Text('Mid')),
                      const PopupMenuItem(value: 'ADC', child: Text('ADC')),
                      const PopupMenuItem(value: 'Supp', child: Text('Supp')),
                    ],
                    onSelected: (value) {
                      setState(() {
                        user.lane = value ?? '';
                      });
                      updateUserLane(userId, user.lane);
                    },
                  ),
                ),
                ListTile(
                  title: Text('Equipa: ${user.equipa}'),
                  trailing: PopupMenuButton<int>(
                    icon: const Icon(Icons.arrow_drop_down),
                    itemBuilder: (context) {
                      return teams.map((team) {
                        return PopupMenuItem<int>(
                          value: teams.indexOf(team),
                          child: Text(team.name),
                        );
                      }).toList();
                    },
                    onSelected: (index) {
                      setState(() {
                        user.equipa = teams[index].name;
                      });
                      // Save the updated user information here
                      updateUserTeam(userId, user.equipa);
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  setState(() {
                    user.lane = ilane;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      );
    },
  );
}


/*
  void _showDeleteConfirmation(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apagar Conta'),
          content: const Text('Tem a certeza que deseja apagar a sua conta?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                User.deleteUser(users, user);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                 
                                  return const MyStatefulWidget();
                                }),
                              );
              },
              style: TextButton.styleFrom(
                primary: Colors.red,
              ),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
  */

  /*
   void _showCreateTeam(BuildContext context) {
      String teamName = '';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Criar Equipa'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Digite o nome da equipa:'),
                const SizedBox(height: 10.0),
                TextFormField(
                  onChanged: (value) {
                    teamName = value;
                  },
                  decoration: const InputDecoration(labelText: 'Nome da Equipa'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  _createTeam(context, teamName);
                  Navigator.of(context).pop(); 
                },
                style: TextButton.styleFrom(
                  primary: Colors.green,
                ),
                child: const Text('Confirmar'),
              ),
            ],
          );
        },
      );
}
*/

/*
void _createTeam(BuildContext context, String teamName) {
  try {
    
    Team newTeam = Team(name: teamName);

  
    teams.add(newTeam);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Equipa criada com sucesso!'),
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Erro ao criar a equipa'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
*/
}

