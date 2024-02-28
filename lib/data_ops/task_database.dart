import 'package:checkmate_2/models/task_list_model.dart';
import 'package:flutter/material.dart';

class TaskDatabase extends ChangeNotifier {
  late List<TaskList> taskLists = [];

  void createTaskList(String taskListName) {
    taskLists.add(TaskList(taskListName, []));
  }

  // Function to trigger toggle task function in the respective task list.
  void toggleTask(String taskListName, String taskName) {
    // Getting the appropriate task list.
    int taskListIndex =
        taskLists.indexWhere((taskList) => taskList.name == taskListName);

    // Calling the function
    taskLists[taskListIndex].toggleTask(taskName);

    // Notifying listeners of change
    notifyListeners();
  }

  // Function to trigger addTask in the respective taskList
  void addTask(String taskName, String taskListName) {
    // Getting the appropriate task list.
    int taskListIndex =
        taskLists.indexWhere((taskList) => taskList.name == taskListName);

    // Calling the function
    taskLists[taskListIndex].addTask(taskName);

    // Notifying Listeners
    notifyListeners();
  }

  // To trigger the taskExist function in the specific taskList
  bool taskExists(String taskName, String taskListName) {
    // Getting the appropriate task list.
    int taskListIndex =
        taskLists.indexWhere((taskList) => taskList.name == taskListName);

    // Calling the function and returning the value
    return taskLists[taskListIndex].taskExists(taskName);
  }
}
