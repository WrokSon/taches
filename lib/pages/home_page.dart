import 'package:flutter/material.dart';
import 'package:taches/models/tri_enum.dart';
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
      body: FutureBuilder(
        future: notifier.init(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListenableBuilder(
              listenable: notifier,
              builder: (context, child) => Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text("Masquer les taches fini : "),
                                Checkbox(
                                  value: notifier.withOutComplete,
                                  onChanged: (value) {
                                    notifier.withOutComplete = value!;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Text("Tri : "),
                                SizedBox(
                                  width:
                                      200, // Ajout d'une largeur fixe au SizedBox
                                  child: DropdownButtonFormField<Tri>(
                                    items: const [
                                      DropdownMenuItem(
                                        value: Tri.NORMAL,
                                        child: Text("Normal"),
                                      ),
                                      DropdownMenuItem(
                                        value: Tri.DATE,
                                        child: Text("Date"),
                                      ),
                                    ],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    value: notifier.currentTri,
                                    onChanged: (value) async {
                                      setState(() {
                                        notifier.currentTri = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "tache non valide";
                                        } else if (notifier.isIn(value)) {
                                          return "tache déjà dans la liste";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText:
                                              "Ajouter une nouvelle tache"),
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
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
