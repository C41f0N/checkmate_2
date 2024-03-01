import 'package:flutter/material.dart';

class Task extends ChangeNotifier {
  late String name;
  late bool completed;

  Task(this.name, this.completed);

  Task.fromJson(Map<String, dynamic> jsonData) {
    name = jsonData["name"];
    completed = jsonData["completed"];
  }

  // To toggle the task completion
  void toggleCompletion() {
    completed = !completed;
    notifyListeners();
  }

  // Convert object to Json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'completed': completed,
    };
  }
}
