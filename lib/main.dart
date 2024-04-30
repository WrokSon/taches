import 'package:flutter/material.dart';
import 'package:taches/pages/add_edit_page.dart';
import 'package:taches/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // gerer la navigation entre le pages
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // vers la page Home
      case HomePage.nameRoute:
        return MaterialPageRoute(builder: (context) => const HomePage());
      // vers la page AddEdit
      case AddEditPage.nameRoute:
        return MaterialPageRoute(builder: (context) => AddEditPage(id : settings.arguments as int));
      // page demander non existante
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text("Erreur"),
              centerTitle: true,
            ),
            body: const Center(
              child: Text("Page inexistante"),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taches',
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.nameRoute,
      onGenerateRoute: (settings) => generateRoute(settings),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
