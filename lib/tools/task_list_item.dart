import 'package:flutter/material.dart';
import 'package:taches/models/task.dart';
import 'package:taches/pages/detail_page.dart';
import 'package:taches/pages/edit_page.dart';
import 'package:taches/tools/services.dart';
import 'package:taches/tools/task_notifier.dart';

class TaskListItem extends StatefulWidget {
  final Task task; // Tâche associée à cet élément de liste
  const TaskListItem({Key? key, required this.task})
      : super(key: key); // Constructeur avec la tâche comme paramètre

  @override
  State<TaskListItem> createState() =>
      _TaskListItem(task); // Création de l'état de l'élément de liste
}

class _TaskListItem extends State<TaskListItem> {
  final Task _task; // Tâche associée à cet élément de liste
  _TaskListItem(this._task); // Constructeur pour initialiser la tâche

  @override
  Widget build(BuildContext context) {
    // Instance du notifier pour gérer les tâches
    final notifier = TaskNotifier.instance;
    // Couleur de l'icône en fonction de l'état de la tâche
    Color? colorIcon = _task.isFinish ? getSubtitleColor() : Colors.yellow;

    return GestureDetector(
      onTap: () {
        // Redirection vers la page d'édition de la tâche lorsqu'on appuie sur l'élément de liste
        Navigator.pushNamed(context, EditPage.nameRoute, arguments: _task.id);
      },
      onDoubleTap: () {
        // Changement de l'état de la tâche lorsqu'on double-clique sur l'élément de liste
        setState(() {
          _task.isFinish = true;
          notifier.editTask(_task);
        });
      },
      child: Card(
        elevation: 0,
        child: Row(
          children: [
            // Section etoile
            IconButton(
              onPressed: () {
                // Modification de la priorité de la tâche lorsqu'on appuie sur l'icône d'étoile
                setState(() {
                  _task.isPrio = !_task.isPrio;
                  notifier.editTask(_task);
                });
              },
              icon: _task.isPrio
                  ? Icon(
                      Icons.star,
                      color: colorIcon,
                    )
                  : Icon(
                      Icons.star_border,
                      color: colorIcon,
                    ),
            ),
            // Setion Tache effectue (CheckBox)
            Checkbox(
              value: _task.isFinish,
              activeColor: getSubtitleColor(),
              onChanged: (value) {
                // Changement de l'état de la tâche lorsqu'on coche/décoche la case
                setState(() {
                  _task.isFinish = value!;
                  notifier.editTask(_task);
                  colorIcon =
                      _task.isFinish ? getSubtitleColor() : Colors.yellow;
                });
              },
            ),
            Expanded(
              // section contenu de la tache + sa date
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _task.content,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _task.isFinish ? getSubtitleColor() : Colors.black,
                    ),
                  ),
                  _task.dateEnd != null
                      ? Text(
                          dateToString(_task.dateEnd),
                          style: TextStyle(
                            color: getSubtitleColor(),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                // Redirection vers la page de détail de la tâche lorsqu'on appuie sur l'icône d'information
                Navigator.pushNamed(context, DetailPage.nameRoute,
                    arguments: _task);
              },
              icon: Icon(
                Icons.info,
                color: _task.isFinish ? getSubtitleColor() : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
