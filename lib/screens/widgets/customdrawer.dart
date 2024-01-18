import 'package:aplicacao/screens/registro.dart';
import 'package:aplicacao/screens/login.dart';
import 'package:flutter/material.dart';



class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hover = false;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 100, 
            child: const DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 25, 25, 25),
              ),
              child: Text('Menu', style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
          ListTile(
            hoverColor: Color.fromARGB(255, 112, 112, 112),
            title: const Text('Pagina Principal'),
            onTap: () => Navigator.of(context).pushNamed('/'),
            
          ),
          
          ListTile(
            hoverColor: Color.fromARGB(255, 112, 112, 112),
            title: const Text('Registro'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RegisterPage();
            })),
          ),
           ListTile(
            hoverColor: Color.fromARGB(255, 112, 112, 112),
            title: const Text('Login'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LoginPage();
            })),
          ),
        ],
      ),
    );
  }
}