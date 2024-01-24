import 'package:aplicacao/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:aplicacao/screens/widgets/customdrawer.dart'; 
import 'package:aplicacao/screens/data/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: RegisterPage());
  }
}

class RegisterPage extends StatelessWidget {
  String email = '';
  String password = '';
  String repeatPassword = '';
  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
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
                  const SizedBox(height: 8.0),
                  
                  TextFormField(
                    onChanged: (value) {
                      repeatPassword = value;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Repeat Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                   const Text(
                    'A palavra-passe deve ter pelo menos 6 caracteres.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      if (email == '' || password == '' || repeatPassword == ''){
                       _showPopupemptyregistro(context);
                       return;
                      }

                      if(password != repeatPassword){
                        _showPopuppass(context);
                        return;
                      }

                      if (password.length < 6) {
                        _showPopupshortpassword(context);
                        return;
                      }

                      if(!email.contains('@')){
                        _showPopupemail(context);
                        return;
                      }
                      
                      auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                          onEmailAlreadyInUse: (bool isEmailInUse) {
                            if (isEmailInUse) {
                              _showPopupemptyemailmatch(context);
                            }
                          },
                        );
                     
                      

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          }),
                        );
                      _showPopupVerifyEmail(context);
                    },
                    child: const Text('Registar'),
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

void _showPopupVerifyEmail(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirme o Email'),
        content: const Text(
          'Um email de verificação foi enviado para o endereço de email. Por favor, confirme a sua conta.',
        ),
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


void _showPopupemptyregistro(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro no Registro'),
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

void _showPopuppass(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro na Password'),
          content: const Text('Palavra-passe não coincide'),
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

  void _showPopupemptyemailmatch(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro no Email'),
          content: const Text('Existe uma conta com o mesmo email'),
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

  void _showPopupshortpassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro na Palavra-passe'),
          content: const Text('A palavra passe tem de ter pelo menos 6 caracteres'),
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

