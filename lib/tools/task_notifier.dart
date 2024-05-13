import 'package:flutter/foundation.dart';
import 'package:taches/models/my_data_base.dart';
import 'package:taches/models/shared_preference.dart';
import 'package:taches/models/task.dart';
import 'package:taches/models/tri_enum.dart';
import 'package:uuid/uuid.dart';

// cette classe va gerer la liste des taches
class TaskNotifier with ChangeNotifier {
  bool _withOutComplete = false;
  Tri _tri = Tri.NORMAL;
  final _sharedPref = SharedPreference();
  final _db = MyDataBase();
  List<Task> _tasks = [];
  static final TaskNotifier instance = TaskNotifier._();
  TaskNotifier._();

  Future<List<Task>> init() async {
    _tri = await _sharedPref.getTri();
    _withOutComplete = await _sharedPref.getShowIsFinish();
    _tasks = await _db.tasks();
    notifyListeners();
    return _tasks;
  }

  List<Task> get tasks {
    // verifier toute les date
    _tasks.forEach((task) {
      if (!task.isDateNotPassed()) {
        task.isFinish = true;
      }
    });

    // tri
    List<Task> listCopy = Task.copyList(_tasks);
    if (_withOutComplete) {
      listCopy = listCopy.where((element) => !element.isFinish).toList();
    }
    switch (_tri) {
      case Tri.NORMAL:
        listCopy.sort(Task.triNormal);
        break;
      case Tri.DATE:
        listCopy.sort(Task.triParDate);
        break;
      default:
        listCopy.sort(Task.triNormal);
        break;
    }

    return listCopy;
  }

  bool get withOutComplete => _withOutComplete;
  Tri get currentTri => _tri;
  // set _withOutComplete
  void set withOutComplete(bool value) {
    _withOutComplete = value;
    _sharedPref.setShowIsFinish(value);
    notifyListeners();
  }

  // set tri
  void set currentTri(Tri value) {
    _tri = value;
    _sharedPref.setTri(value);
    notifyListeners();
  }

  // supprimer un element a la postion index et avertir les autres
  void removeTaskAt(int index) {
    _db.deleteTask(_tasks[index].id);
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
    Task task =
        Task(id: const Uuid().v4(), content: content, dateEdit: DateTime.now());
    _tasks.add(task);
    _db.insertTask(task);
    notifyListeners();
  }

  // ajouter ou modifier une tache
  void editTask(Task task) {
    _tasks.firstWhere((element) => element.id == task.id).copyFrom(task);
    _db.updateTask(task);
    notifyListeners();
  }
}
