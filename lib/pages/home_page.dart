import 'package:flutter/material.dart';
import 'package:taches/models/tri_enum.dart';
import 'package:taches/tools/services.dart';
import 'package:taches/tools/task_list_item.dart';
import 'package:taches/tools/task_notifier.dart';

class HomePage extends StatefulWidget {
  // Route vers cette page
  static const String nameRoute = "/";

  // Constructeur de la page
  const HomePage({Key? key}) : super(key: key);

  @override
  // Création de l'état de la page d'accueil
  State<HomePage> createState() => _HomePage();
}

// Gestion de la page d'accueil
class _HomePage extends State<HomePage> {
  final taskContentController =
      TextEditingController(); // Contrôleur de texte pour le champ de saisie de la tâche
  final _keyForm = GlobalKey<FormState>(); // Clé pour le formulaire

  @override
  void dispose() {
    super.dispose();
    // Libération des ressources du contrôleur de texte
    taskContentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Instance du notifier pour gérer les tâches
    final notifier = TaskNotifier.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Taches"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: notifier
            .init(), // Initialisation du notifier (chargement des tâches)
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Si les données sont disponibles
            return ListenableBuilder(
              listenable: notifier,
              builder: (context, child) => Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    // Bouton pour masquer les tâches terminées
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              child: Text(
                                "Masquer les taches finis",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                notifier.withOutComplete =
                                    !notifier.withOutComplete;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: notifier.withOutComplete
                                    ? getSubtitleColor()
                                    : getBackgroundColorButton(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        // Étiquette pour le tri
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Tri : "),
                              SizedBox(
                                height: 60,
                                width: 110,
                                child: DropdownButtonFormField<Tri>(
                                  items: const [
                                    // liste des options
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
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Couleur de la bordure du champ en cas de focus
                                    ),
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
                    // Liste des tâches
                    Expanded(
                      flex: 20,
                      child: ListView.builder(
                        itemBuilder: (context, index) => Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            notifier.removeTaskAt(notifier.tasks[index]
                                .id); // Supprimer la tâche lorsqu'elle est balayée
                          },
                          background: Container(
                              color: Colors
                                  .red), // Fond rouge lors du balayage pour supprimer
                          child: TaskListItem(
                              task: notifier
                                  .tasks[index]), // Élément de liste de tâche
                        ),
                        itemCount: notifier
                            .tasks.length, // Nombre d'éléments dans la liste
                      ),
                    ),
                    // Formulaire pour ajouter une nouvelle tâche
                    Card(
                      color: Colors.blue[100], // Couleur de fond de la carte
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Expanded(
                          child: Form(
                            key: _keyForm, // Clé du formulaire
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: taskContentController,
                                    validator: (value) {
                                      // Validation du champ de saisie
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Tu dois ercire une tache";
                                      } else if (notifier.isIn(value.trim())) {
                                        // Si la tâche est déjà dans la liste
                                        return "tache déjà dans la liste";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      hintText:
                                          "Ajouter une nouvelle tache", // Texte d'aide pour le champ de saisie
                                    ),
                                  ),
                                ),
                                // Button d'ajout de tâche
                                IconButton.filled(
                                  onPressed: () {
                                    if (_keyForm.currentState!.validate()) {
                                      notifier.addTask(taskContentController
                                          .text
                                          .trim()); // Ajouter la tâche lorsque le formulaire est valide
                                      taskContentController.text =
                                          ""; // Effacer le champ de saisie après l'ajout de la tâche
                                    }
                                  },
                                  icon: const Icon(Icons.add),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateColor
                                        .resolveWith((states) =>
                                            getBackgroundColorButton()), // Couleur de fond du bouton
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child:
                CircularProgressIndicator(), // Indicateur de chargement lors de l'initialisation
          );
        },
      ),
    );
  }
}
