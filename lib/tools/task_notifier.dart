import 'package:flutter/foundation.dart';
import 'package:taches/models/task.dart';

// cette classe va gerer la liste des taches
class TaskNotifier with ChangeNotifier {
  final List<Task> _tasks = [
    Task(id: 0, content: "Manger ses pieds", isFinish: true),
    Task(id: 1, content: "Danser ce soir", dateEnd: DateTime.now()),
    Task(
        id: 2,
        content: "Coder ta maman",
        description: "je n'ai rien a racompter"),
    Task(id: 3, content: "Dormir a l'heure", isPrio: true),
  ];
  static final TaskNotifier instance = TaskNotifier._();
  TaskNotifier._();

  List<Task> get tasks => _tasks;

  // supprimer un element a la postion index et avertir les autres
  void removeTaskAt(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  // ajouter ou modifier une tache
  void addEditTask(Task task) {
    if (task.id != -1) {
      Task myTask = tasks.firstWhere((element) => element.id == task.id);
      myTask = task;
    } else {
      task.id = _tasks.length + 2;
      tasks.add(task);
    }
    notifyListeners();
  }
}
