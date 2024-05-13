import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:taches/models/task.dart';
import 'package:taches/pages/detail_page.dart';
import 'package:taches/pages/edit_page.dart';
import 'package:taches/tools/services.dart';
import 'package:taches/tools/task_notifier.dart';

class TaskListItem extends StatefulWidget {
  final Task task;
  const TaskListItem({super.key, required this.task});

  @override
  State<TaskListItem> createState() => _TaskListItem(task);
}

class _TaskListItem extends State<TaskListItem> {
  final Task _task;
  _TaskListItem(this._task);

  // construction de la forme de l'item
  @override
  Widget build(BuildContext context) {
    final notifier = TaskNotifier.instance;
    // couleurs utils
    Color? colorIcon = _task.isFinish ? getSubtitleColor() : Colors.yellow;
    return GestureDetector(
      onTap: () {
        // direction pour modifier la tache
        Navigator.pushNamed(context, EditPage.nameRoute, arguments: _task.id);
      },
      onDoubleTap: () {
        // terminer la tache
        setState(() {
          _task.isFinish = true;
          notifier.editTask(_task);
        });
      },
      // forme de la tache
      child: Card(
        elevation: 0,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
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
            Checkbox(
              value: _task.isFinish,
              activeColor: getSubtitleColor(),
              onChanged: (value) {
                setState(() {
                  _task.isFinish = value!;
                  notifier.editTask(_task);
                  colorIcon =
                      _task.isFinish ? getSubtitleColor() : Colors.yellow;
                });
              },
            ),
            Expanded(
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
                  Text(
                    dateToString(_task.dateEnd),
                    style: TextStyle(
                      color: getSubtitleColor(),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
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
