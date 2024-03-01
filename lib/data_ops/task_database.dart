import 'package:checkmate_2/models/task_list_model.dart';
import 'package:checkmate_2/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskDatabase extends ChangeNotifier {
  late List<TaskList> taskLists;
  late String currentTaskListName;

  TaskDatabase() {
    taskLists = [
      TaskList("New Task List", [
        Task("task 1", true),
        Task("task 2", false),
        Task("task 3", true),
      ])
    ];

    currentTaskListName = "New Task List";
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

  // Function to add a new task list
  void addTaskList(String taskListName) {
    // Check if a list with the same name exists
    if (!taskListExists(taskListName)) {
      // Add the task list
      taskLists.add(TaskList(taskListName, []));

      // Notify listeners
      notifyListeners();
    }
  }

  // Function to check if a task list already exists by name
  bool taskListExists(String taskListName) {
    return taskLists.indexWhere((taskList) => taskList.name == taskListName) !=
        -1;
  }

  TaskList getCurrentTaskList() {
    return taskLists
        .firstWhere((taskList) => taskList.name == currentTaskListName);
  }

  void setCurrentTaskList(String listName) {
    if (taskLists.indexWhere((taskList) => taskList.name == listName) != -1) {
      currentTaskListName = listName;

      notifyListeners();
    }
  }
}
