import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:taches/models/task.dart';
import 'package:taches/tools/services.dart';
import 'package:taches/tools/task_notifier.dart';

class EditPage extends StatefulWidget {
  final String id;
  // route vers cette page
  static const String nameRoute = "/edit";
  // constructeur
  const EditPage({super.key, required this.id});

  @override
  State<EditPage> createState() => _EditPage(id);
}

class _EditPage extends State<EditPage> {
  late Task _task;
  // formulaire
  final _keyForm = GlobalKey<FormState>();
  final taskContentController = TextEditingController();
  final addrContentController = TextEditingController();
  final descriptionController = TextEditingController();
  final notifier = TaskNotifier.instance;
  _EditPage(String id) {
    _task = notifier.tasks.firstWhere((element) => element.id == id);
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
    bool isValideAddr = false;
    // affichage
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier"),
        centerTitle: true,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        margin: const EdgeInsets.all(20),
        child: Form(
          key: _keyForm,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                                if (value == null || value.trim().isEmpty) {
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
                              validator: (value) {
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
                                dateEnd = value;
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
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final addr = addrContentController.text;
                    final tempPostion = await checkAddress(addr);
                    if (tempPostion != null) {
                      setState(() {
                        isValideAddr = true;
                      });
                    }
                    if (_keyForm.currentState!.validate()) {
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
                      notifier.editTask(_task);
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
