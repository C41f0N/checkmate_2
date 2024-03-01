import 'package:checkmate_2/models/task_model.dart';

class TaskList {
  late String name;
  late List<Task> tasks;

  TaskList(this.name, this.tasks);

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
