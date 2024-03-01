import 'package:checkmate_2/models/task_model.dart';

class TaskList {
  late String name;
  late List<Task> tasks;

  TaskList(this.name, this.tasks);

  // To create object from jsonData
  TaskList.fromJson(Map<String, dynamic> jsonData) {
    // Get the taskList name from the Map structure
    name = jsonData["name"];

    // Loading the Map structure for tasks
    List<dynamic> jsonTasks = jsonData["tasks"];

    // Using the loaded Map structure to create Task objects
    tasks = jsonTasks.map((jsonTask) => Task.fromJson(jsonTask)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "tasks": tasks.map((task) => task.toJson()).toList(),
    };
  }

  // To add a task to the list
  void addTask(String taskName) {
    // Add the task if another one by it's name exists
    if (!taskExists(taskName)) {
      tasks.add(Task(taskName, false));
    }
  }

  // To add a task to the list
  void deleteTask(String taskName) {
    // Delete the first occourance of task
    tasks.removeWhere((task) => task.name == taskName);
  }

  // To delete all completed tasks
  void deleteAllCompletedTasks() {
    tasks.removeWhere((task) => task.completed);
  }

  // To toggle a task's completion status
  void toggleTask(String taskName) {
    int toggleIndex = tasks.indexWhere((task) => task.name == taskName);

    tasks[toggleIndex].toggleCompletion();
  }

  // To check if a task already exists by name
  bool taskExists(String taskName) {
    return tasks.indexWhere((task) => task.name == taskName) != -1;
  }
}
