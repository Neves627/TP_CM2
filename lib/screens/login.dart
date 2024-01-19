import 'package:aplicacao/screens/data/user.dart';
import 'package:aplicacao/screens/registro.dart';
import 'package:aplicacao/screens/user_page.dart';
import 'package:aplicacao/screens/useradmin_page.dart';
import 'package:aplicacao/screens/widgets/customdrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:aplicacao/screens/data/auth.dart';
 


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginPage());
  }
}

class LoginPage extends StatelessWidget {
  String email = '';
  String password = '';
  final Auth auth = Auth();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      ),
      drawer: const CustomDrawer(),
      body: Container(
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
        child: Center(
          child: SizedBox(
            width: 370.0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  
                  Container(
                    height: 100.0,
                    child: Image.asset(
                      'assets/Logo.png',
                    ),
                  ),
                  const SizedBox(height: 16.0), 

                  
                  TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  
                    TextButton(
                      onPressed: () {
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return RegisterPage();
                          }),
                        );
                      },
                      child: const Text(
                        "Não tens uma conta, cria aqui",
                        style: TextStyle(
                          color: Colors.blue, 
                          decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                                        

                                        const SizedBox(height: 20.0),
                                        ElevatedButton(
                            onPressed: () async {
                              if (email == '' || password == '') {
                                _showPopupemptylogin(context);
                                return;
                              }
                              if (!email.contains('@')) {
                                _showPopupemail(context);
                                return;
                              }

                              try {

                                await auth.signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                String? userId = await auth.checkUidInCollection();
                                if (userId != null) {
                                  int? adminField = await getadm(userId);
                                  if (adminField == 0) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserProfilePage(userId: userId),
                                      ),
                                    );
                                  } else if (adminField == 1) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AdminProfilePage(userId: userId),
                                      ),
                                    );
                                  }
                                }
                                print("Sucesso");
                                auth.checkUidInCollection();
                                // Successful login
                                
                              } catch (e) {
                                // Handle login errors
                                print("Login error: $e");
                                _showPopupnoacc(context);
                              }
                            },
                            child: const Text('Login'),
                    ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }

void _showPopupemptylogin(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro no Login'),
          content: const Text('Preencha os campos todos'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showPopupemail(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro no Email'),
          content: const Text('Formato de email invalido'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showPopupnoacc(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conta não existe'),
          content: const Text('Email ou password invalidos'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
