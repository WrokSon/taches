import 'package:flutter/material.dart';
import 'package:taches/pages/add_edit_page.dart';
import 'package:taches/tools/task_list_item.dart';
import 'package:taches/tools/task_notifier.dart';

class HomePage extends StatefulWidget {
  // route vers cette page
  static const String nameRoute = "/";

  // constructeur de la page
  const HomePage({super.key});
  @override
  // creation de la page Home
  State<HomePage> createState() => _HomePage();
}

// gestion de la page Home
class _HomePage extends State<HomePage> {
  // constructuction de la page  de la page

  @override
  Widget build(BuildContext context) {
    // TODO : recuperer le sharedPreference
    final notifier = TaskNotifier.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Taches"),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: notifier,
        builder: (context, child) => Container(
          margin: const EdgeInsets.all(10),
          child: ListView.builder(
            itemBuilder: (context, index) => Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                notifier.removeTaskAt(index);
              },
              background: Container(color: Colors.red),
              child: TaskListItem(task: notifier.tasks[index]),
            ),
            itemCount: notifier.tasks.length,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddEditPage.nameRoute, arguments: -1);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
