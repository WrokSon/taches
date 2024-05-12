import 'package:latlong2/latlong.dart';

class Task {
  String id;
  String content;
  String? description;
  late bool isPrio;
  late bool isFinish;
  DateTime? dateEnd;
  DateTime? dateEdit;
  String? address;
  LatLng? position;
  Task(
      {required this.id,
      required this.content,
      this.description,
      bool? isPrio,
      bool? isFinish,
      this.dateEnd,
      this.dateEdit,
      this.address,
      this.position}) {
    this.isFinish = isFinish ?? false;
    this.isPrio = isPrio ?? false;
  }
}
