import 'package:aplicacao/screens/widgets/customdrawer.dart';
import 'package:flutter/material.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  void updateCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
        title: const Text("Opportunity"),
      ),
       body: SingleChildScrollView(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'Logo.png', 
              width: 400.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            const Text(
              'Bem-vindo ao Opportunity!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Oportunidade única de vencer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),
            const Text(
              'Formato Swiss para Torneios:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'No Opportunity utilizamos o formato Swiss que é um método usado para realizar torneios em que os participantes '
              'não são eliminados após cada rodada. Em vez disso, os jogadores ou equipes são selecionados '
              'contra oponentes com desempenhos semelhantes a cada rodada. Isso proporciona uma experiência '
              'mais equilibrada e justa, permitindo que todos joguem vários jogos, independentemente dos resultados anteriores.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16.0),
            

           
            Image.asset(
              'swiss.png', 
              width: 400.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),

        
          ],
        ),
      ),
    ));
    
  }
}
