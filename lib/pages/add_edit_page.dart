import 'package:flutter/material.dart';
import 'package:taches/models/task.dart';

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
  _AddEditPage(int id) {
    _isAdding = id == -1;
    _task = _isAdding
        ? Task(content: "")
        : Task(
            content: "Coder ta maman", description: "je n'ai rien a racompter");
  }

  @override
  void dispose() {
    super.dispose();
    taskContentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    const Text("Contenu"),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Ex: Avoir plus de 16",
                      ),
                      validator: (value) {
                        if (value != null || value!.isEmpty) {
                          return "Tu dois ercire une tache";
                        }
                        return null;
                      },
                      controller: taskContentController,
                    ),
                  ],
                ),
              ),
              //TODO : continuer l'adresse
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    const Text("Adresse"),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Ex: Avoir plus de 16",
                      ),
                      validator: (value) {
                        if (value != null || value!.isEmpty) {
                          return "Tu dois ercire une tache";
                        }
                        return null;
                      },
                      controller: taskContentController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
