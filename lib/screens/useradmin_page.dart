import 'package:aplicacao/screens/widgets/customdrawer.dart';
import 'package:aplicacao/screens/data/user.dart';
import 'package:flutter/material.dart';


class AdminProfilePage extends StatefulWidget {
  final String userId;
  

  AdminProfilePage({required this.userId});

  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  late Future<User?> userInfo;
  late User? adminUserData;

  @override
  void initState() {
    super.initState();
    userInfo = getUser();
    // Use widget.userId to access the userId property of the widget
    getUserData(widget.userId).then((user) {
      setState(() {
        adminUserData = user;
      });
    });
  }

  Future<User?> getUser() async {
    User? userData = await getUserData(widget.userId);
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 28, 28),
      appBar: AppBar(
        title: const Text('Perfil do Administrador'),
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
        actions: [
          ElevatedButton(
            onPressed: () {
              //_showRemoveUserConfirmation(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text('Remover Usuário'),
          ),
          ElevatedButton(
            onPressed: () {
             //_showRemoveTeamConfirmation(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text('Remover Equipa'),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder<User?>(
        future: userInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text('Error loading admin data.'),
            );
          } else {
            User admin = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
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
                                'Informações do Administrador',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Text('Nome: ${admin.nome}'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Card(
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lista de Usuários',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              ListView.builder(
                                shrinkWrap: true,
                                //itemCount: userList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text('Nome: ${adminUserData!.nome}'),
                                    subtitle: Text('Email: ${adminUserData!.email}'),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lista de Equipas',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              ListView.builder(
                                shrinkWrap: true,
                                //itemCount: teams.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    //title: Text('Nome: ${teams[index].name}'),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

/*
  void _showRemoveUserConfirmation(BuildContext context) {
  String userEmail = ''; 

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Remover Usuário'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Digite o email do usuário a ser removido:'),
            const SizedBox(height: 10.0),
            TextFormField(
              onChanged: (value) {
                userEmail = value;
              },
              decoration: const InputDecoration(labelText: 'Email do Usuário'),
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
              _removeUser(context, userEmail);
              
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                                    
                 return AdminProfilePage(userList: users);
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

//Para remover um utilizador
void _removeUser(BuildContext context, String userEmail) {
  try {
   
    User userToRemove = users.firstWhere((user) => user.email == userEmail);

    
    users.remove(userToRemove);

    
    Navigator.of(context).pop(); 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuário removido com sucesso!'),
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuário não encontrado'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

  void _showRemoveTeamConfirmation(BuildContext context) {
  String teamName = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Remover Equipa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Digite o nome da equipe a ser removida:'),
            const SizedBox(height: 10.0),
            TextFormField(
              onChanged: (value) {
                teamName = value;
              },
              decoration: const InputDecoration(labelText: 'Nome da Equipe'),
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
              _removeTeam(context, teamName);
              Navigator.of(context).pop(); 
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                                    
                 return AdminProfilePage(userList: users);
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

void _removeTeam(BuildContext context, String teamName) {
  try {
    
    Team teamToRemove = teams.firstWhere((team) => team.name == teamName);

    
    teams.remove(teamToRemove);

    
    Navigator.of(context).pop(); 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Equipe removida com sucesso!'),
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Equipe não encontrada'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
*/
}





