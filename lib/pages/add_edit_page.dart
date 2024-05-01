import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:taches/models/task.dart';
import 'package:taches/tools/services.dart';
import 'package:taches/tools/task_notifier.dart';

class AddEditPage extends StatefulWidget {
  final int id;
  // route vers cette page
  static const String nameRoute = "/addEdit";
  // constructeur
  const AddEditPage({super.key, required this.id});

  @override
  State<AddEditPage> createState() => _AddEditPage(id);
}

class _AddEditPage extends State<AddEditPage> {
  late Task _task;
  late bool _isAdding;
  // formulaire
  final _keyForm = GlobalKey<FormState>();
  final taskContentController = TextEditingController();
  final addrContentController = TextEditingController();
  final descriptionController = TextEditingController();
  final notifier = TaskNotifier.instance;
  _AddEditPage(int id) {
    _isAdding = id == -1;
    _task = _isAdding
        ? Task( content: "")
        : notifier.tasks.firstWhere((element) => element.id == id);
  }

  @override
  void dispose() {
    super.dispose();
    taskContentController.dispose();
    addrContentController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // initialisation des champs
    taskContentController.text = _task.content;
    addrContentController.text = _task.address ?? "";
    descriptionController.text = _task.description ?? "";
    DateTime? dateEnd = _task.dateEnd;
    LatLng? tempPostion;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isAdding ? "Ajouter un note" : "Modifier"),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Form(
          key: _keyForm,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Tache a faire"),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Ex: Avoir plus de 16",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Tu dois ercire une tache";
                              }
                              return null;
                            },
                            controller: taskContentController,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Adresse"),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Ex: 5 rue jean-macé 45000 orléans",
                            ),
                            controller: addrContentController,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Date de limite"),
                          DateTimeFormField(
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.black45),
                              errorStyle: TextStyle(color: Colors.redAccent),
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.event_note),
                              hintText: 'Choisir une date',
                            ),
                            initialValue: dateEnd,
                            autovalidateMode: AutovalidateMode.always,
                            mode: DateTimeFieldPickerMode.date,
                            onChanged: (DateTime? value) {
                              setState(() {
                                dateEnd = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Description"),
                          TextFormField(
                            maxLines: 5,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "laissé votre imagination",
                            ),
                            controller: descriptionController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // final addr = addrContentController.text;
                    if (_keyForm.currentState!.validate()) {
                      _task.content = taskContentController.text;
                      _task.address = addrContentController.text;
                      _task.dateEdit = DateTime.now();
                      _task.description = descriptionController.text;
                      _task.dateEnd = dateEnd;
                      _task.position = tempPostion;
                      notifier.addEditTask(_task);
                      print("object");
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Valider"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
