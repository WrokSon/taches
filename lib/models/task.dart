import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  // Méthode pour copier les attributs d'un autre objet Task
  void copyFrom(Task otherTask) {
    id = otherTask.id;
    content = otherTask.content;
    description = otherTask.description;
    isPrio = otherTask.isPrio;
    isFinish = otherTask.isFinish;
    dateEnd = otherTask.dateEnd;
    dateEdit = otherTask.dateEdit;
    address = otherTask.address;
    position = otherTask.position;
  }

  // Méthode pour copier une tâche
  Task copy() {
    return Task(
      id: this.id,
      content: this.content,
      description: this.description,
      isPrio: this.isPrio,
      isFinish: this.isFinish,
      dateEnd: this.dateEnd,
      dateEdit: this.dateEdit,
      address: this.address,
      position: this.position,
    );
  }

  // Méthode pour vérifier si la date n'est pas passée
  bool isDateNotPassed() {
    // Récupérer la date actuelle
    DateTime currentDate = DateTime.now();
    // Vérifier si la date d'échéance est définie et si elle est postérieure à la date actuelle
    return dateEnd != null ? currentDate.isBefore(dateEnd!) : true;
  }

  // Méthode pour copier une liste de tâches
  static List<Task> copyList(List<Task> originalList) {
    List<Task> copiedList = [];
    for (Task task in originalList) {
      copiedList.add(task.copy());
    }
    return copiedList;
  }

  // Fonction de comparaison pour trier les tâches
  static int triNormal(Task a, Task b) {
    // Trier par isFinish (false en premier)
    if (a.isFinish && !b.isFinish) {
      return 1;
    } else if (!a.isFinish && b.isFinish) {
      return -1;
    }

    // Trier par isPrio (true en premier)
    if (a.isPrio && !b.isPrio) {
      return -1;
    } else if (!a.isPrio && b.isPrio) {
      return 1;
    }

    // Si isPrio est égal, trier par date de modification (plus récente en premier)
    if (a.dateEdit != null && b.dateEdit != null) {
      if (b.dateEdit!.isAfter(a.dateEdit!)) {
        return -1;
      } else if (b.dateEdit!.isBefore(a.dateEdit!)) {
        return 1;
      }
    } else if (a.dateEdit != null && b.dateEdit == null) {
      return -1;
    } else if (a.dateEdit == null && b.dateEdit != null) {
      return 1;
    }

    // Si toutes les conditions échouent, maintenir l'ordre actuel
    return 0;
  }

  // Fonction de comparaison pour trier les tâches
  static int triParDate(Task a, Task b) {
    // Trier par isFinish (false en premier)
    if (a.isFinish && !b.isFinish) {
      return 1;
    } else if (!a.isFinish && b.isFinish) {
      return -1;
    }

    // Trier par date d'échéance (de la plus récente à la plus ancienne)
    if (a.dateEnd != null && b.dateEnd != null) {
      if (b.dateEnd!.isAfter(a.dateEnd!)) {
        return -1;
      } else if (b.dateEnd!.isBefore(a.dateEnd!)) {
        return 1;
      }
    } else if (a.dateEnd != null && b.dateEnd == null) {
      return -1;
    } else if (a.dateEnd == null && b.dateEnd != null) {
      return 1;
    }

    // En cas d'égalité de date d'échéance, trier par date de modification ou d'ajout
    if (a.dateEdit != null && b.dateEdit != null) {
      if (b.dateEdit!.isAfter(a.dateEdit!)) {
        return -1;
      } else if (b.dateEdit!.isBefore(a.dateEdit!)) {
        return 1;
      }
    } else if (a.dateEdit != null && b.dateEdit == null) {
      return -1;
    } else if (a.dateEdit == null && b.dateEdit != null) {
      return 1;
    }

    // Si toutes les conditions échouent, maintenir l'ordre actuel
    return 0;
  }
}
