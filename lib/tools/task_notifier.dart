import 'package:flutter/foundation.dart';
import 'package:taches/models/task.dart';
import 'package:uuid/uuid.dart';

// cette classe va gerer la liste des taches
class TaskNotifier with ChangeNotifier {
  final List<Task> _tasks = [
    Task(id: "0", content: "Manger ses pieds", isFinish: true),
    Task(id: "1", content: "Danser ce soir", dateEnd: DateTime.now()),
    Task(
        id: "2",
        content: "Coder ta maman",
        description: "je n'ai rien a racompter"),
    Task(id: "3", content: "Dormir a l'heure", isPrio: true),
  ];
  static final TaskNotifier instance = TaskNotifier._();
  TaskNotifier._();

  List<Task> get tasks => _tasks;

  // supprimer un element a la postion index et avertir les autres
  void removeTaskAt(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  // varifier si une tache est dans la liste
  bool isIn(String content) {
    Task? task = tasks.firstWhere((element) => element.content == content,
        orElse: () => Task(id: '-1', content: ""));
    if (task.content != "") return true;
    return false;
  }

  // ajouter une tache
  void addTask(String content) {
    Task task = Task(id: const Uuid().v4(), content: content);
    _tasks.add(task);
    notifyListeners();
  }

  // ajouter ou modifier une tache
  void editTask(Task task) {
    notifyListeners();
  }
}
