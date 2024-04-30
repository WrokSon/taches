import 'package:taches/models/address.dart';

class Task {
  late int id;
  String content;
  String? description;
  late bool isPrio;
  late bool isFinish;
  DateTime? dateEnd;
  DateTime? dateEdit;
  Address? address;
  Task(
      {int? id,
      required this.content,
      this.description,
      bool? isPrio,
      bool? isFinish,
      this.dateEnd,
      this.dateEdit,
      this.address}) {
    this.id = id ?? 0;
    this.isFinish = isFinish ?? false;
    this.isPrio = isPrio ?? false;
  }
}
