import 'package:flutter/material.dart';

class Task extends ChangeNotifier {
  late String name;
  late bool completed;

  Task(this.name, this.completed);

  // To toggle the task completion
  void toggleCompletion() {
    completed = !completed;
    notifyListeners();
  }
}
