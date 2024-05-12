import 'package:flutter/material.dart';
import 'package:taches/pages/edit_page.dart';
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
  final taskContentController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    taskContentController.dispose();
  }

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
            child: Column(
              children: [
                Expanded(
                  flex: 20,
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
                Card(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Expanded(
                      child: Form(
                        key: _keyForm,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: taskContentController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "tache non valide";
                                  } else if (notifier.isIn(value)) {
                                    return "tache déjà dans la liste";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    hintText: "Ajouter une nouvelle tache"),
                              ),
                            ),
                            IconButton.filled(
                              onPressed: () {
                                if (_keyForm.currentState!.validate()) {
                                  notifier.addTask(
                                      taskContentController.text.trim());
                                  taskContentController.text = "";
                                }
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
