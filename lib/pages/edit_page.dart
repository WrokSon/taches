import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:taches/models/task.dart';
import 'package:taches/tools/services.dart';
import 'package:taches/tools/task_notifier.dart';

class EditPage extends StatefulWidget {
  final String id; // Identifiant de la tâche à éditer

  // Route vers cette page
  static const String nameRoute = "/edit";

  // Constructeur de la page d'édition
  const EditPage({Key? key, required this.id}) : super(key: key);

  @override
  // Création de l'état de la page d'édition
  State<EditPage> createState() => _EditPage(id);
}

// Gestion de la page d'édition
class _EditPage extends State<EditPage> {
  late Task _task; // Tâche à éditer

  // Formulaire
  final _keyForm = GlobalKey<FormState>(); // Clé pour le formulaire
  final taskContentController =
      TextEditingController(); // Contrôleur de texte pour le champ de contenu de la tâche
  final addrContentController =
      TextEditingController(); // Contrôleur de texte pour le champ d'adresse
  final descriptionController =
      TextEditingController(); // Contrôleur de texte pour le champ de description
  final notifier =
      TaskNotifier.instance; // Instance du notifier pour gérer les tâches

  _EditPage(String id) {
    _task = notifier.tasks.firstWhere(
        (element) => element.id == id); // Récupération de la tâche à éditer
  }

  @override
  void dispose() {
    super.dispose();
    // Libération des ressources des contrôleurs de texte
    taskContentController.dispose();
    addrContentController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialisation des champs de texte avec les valeurs de la tâche
    taskContentController.text = _task.content;
    addrContentController.text = _task.address ?? "";
    descriptionController.text = _task.description ?? "";
    DateTime? dateEnd = _task.dateEnd; // Date limite de la tâche
    bool isValideAddr =
        false; // Indicateur pour vérifier si l'adresse est valide

    // Affichage de la page d'édition
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Modifier",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: getBackgroundColor(),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        margin: const EdgeInsets.all(20),
        child: Form(
          key: _keyForm, // Clé du formulaire
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Champ de saisie de la tâche
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section tache
                            const Text("Tache a faire"),
                            TextFormField(
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .blue), // Couleur de la bordure lorsque le champ est en focus
                                ),
                                border: OutlineInputBorder(),
                                // Texte d'aide pour le champ de saisie
                                hintText: "Ex: Aller nager",
                              ),
                              validator: (value) {
                                // Validation du champ de saisie
                                if (value == null || value.trim().isEmpty) {
                                  return "Tu dois ercire une tache";
                                } else if (notifier.isIn(value.trim())) {
                                  // Si la tâche est déjà dans la liste
                                  return "tache déjà dans la liste";
                                }
                                return null;
                              },
                              controller: taskContentController,
                            ),
                          ],
                        ),
                      ),
                      // Champ de saisie de l'adresse
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                                "Adresse"), // Étiquette du champ de saisie
                            TextFormField(
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                border: OutlineInputBorder(),
                                hintText: "Ex: 5 rue de tours 45000 orléans",
                              ),
                              controller: addrContentController,
                              validator: (value) {
                                // Validation de l'adresse
                                if (value != null &&
                                    value.isNotEmpty &&
                                    !isValideAddr) {
                                  return "Addresse invalide";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      // Sélection de la date limite
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Date de limite"),
                            DateTimeFormField(
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(255, 148, 199, 240),
                                hintStyle: TextStyle(color: Colors.black45),
                                errorStyle: TextStyle(color: Colors.redAccent),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .blue), // Couleur de la bordure lorsque le champ est en focus
                                ),
                                suffixIcon: Icon(Icons.event_note),
                                hintText: 'Choisir une date',
                              ),
                              initialValue:
                                  dateEnd, // Valeur initiale de la date
                              autovalidateMode: AutovalidateMode
                                  .always, // retour visuel (champ rempli)
                              mode: DateTimeFieldPickerMode.date,
                              onChanged: (DateTime? value) {
                                dateEnd =
                                    value; // Mise à jour de la date limite
                              },
                            ),
                          ],
                        ),
                      ),
                      // Champ de saisie de la description
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Description"),
                            TextFormField(
                              maxLines:
                                  5, // Nombre maximum de lignes pour le champ de saisie
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                border: OutlineInputBorder(),
                                hintText: "Ajouter une description",
                              ),
                              controller: descriptionController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bouton de validation
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final addr = addrContentController.text;
                    final tempPostion =
                        await checkAddress(addr); // Vérification de l'adresse
                    if (tempPostion != null) {
                      setState(() {
                        isValideAddr = true; // Adresse valide
                      });
                    }
                    if (_keyForm.currentState!.validate()) {
                      // Validation du formulaire
                      // Mise à jour des atributs de la tache
                      _task.content = taskContentController.text.trim();
                      _task.address = addrContentController.text.trim();
                      _task.dateEdit = DateTime.now();
                      _task.description =
                          descriptionController.text.trim().isNotEmpty
                              ? descriptionController.text.trim()
                              : null;
                      _task.dateEnd = dateEnd;
                      _task.isFinish = false;
                      _task.position = tempPostion;
                      notifier.editTask(_task); // Édition de la tâche
                      Navigator.pop(context); // Retour à la page précédente
                    }
                  },
                  child: const Text(
                    "Valider",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        getBackgroundColor(), // Couleur de fond du bouton
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Forme du bouton
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
