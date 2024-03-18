import 'dart:convert';

import 'package:checkmate_2/models/task_list_model.dart';
import 'package:checkmate_2/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TaskDatabase extends ChangeNotifier {
  late List<TaskList> taskLists;
  late String currentTaskListName;

  Box localDatabase = Hive.box("CHECKMATE_DATABASE");

  TaskDatabase() {
    String? previouslyStoredData = localDatabase.get("JSON_TASKS_DATA");

    // First time opening the app
    if (previouslyStoredData == null) {
      // Creating default data
      loadDefaultData();

      // Save data to local database
      saveDataToDevice();
    } else {
      // Fetch tasks and task lists
      getDataFromDevice();
      currentTaskListName = taskLists[0].name;
    }
  }

  //
  // Task Operations
  //

  void loadDefaultData() {
    taskLists = [
      TaskList("My Daily Routine", [
        Task("Make bed", true),
        Task("Make eggs", false),
        Task("Go to work", false),
      ])
    ];

    currentTaskListName = taskLists[0].name;
  }

  // Function to trigger toggle task function in the respective task list.
  void toggleTask(String taskListName, String taskName) {
    // Getting the appropriate task list.
    int taskListIndex =
        taskLists.indexWhere((taskList) => taskList.name == taskListName);

    // Calling the function
    taskLists[taskListIndex].toggleTask(taskName);

    // Save data to local database
    saveDataToDevice();

    // Notifying listeners of change
    notifyListeners();
  }

  // Function to trigger addTask in the respective taskList
  void addTask({
    required String taskName,
    required String taskListName,
    bool completed = false,
  }) {
    // Getting the appropriate task list.
    int taskListIndex =
        taskLists.indexWhere((taskList) => taskList.name == taskListName);

    // Calling the function
    taskLists[taskListIndex].addTask(taskName: taskName, completed: completed);

    // Save data to local database
    saveDataToDevice();

    // Notifying Listeners
    notifyListeners();
  }

  // Function to trigger deleteTask in the respective taskList
  void deleteTask(String taskName, String taskListName) {
    // Getting the appropriate task list.
    int taskListIndex =
        taskLists.indexWhere((taskList) => taskList.name == taskListName);

    // Calling the function
    taskLists[taskListIndex].deleteTask(taskName);

    // Save data to local database
    saveDataToDevice();

    // Notifying Listeners
    notifyListeners();
  }

  // Function to trigger editTask in the respective taskList
  void editTask(String oldtaskName, String newTaskName, String taskListName) {
    // Getting the appropriate task list.
    int taskListIndex =
        taskLists.indexWhere((taskList) => taskList.name == taskListName);

    // Calling the function
    taskLists[taskListIndex].editTask(oldtaskName, newTaskName);

    // Save data to local database
    saveDataToDevice();

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

  // Transfer a task from one list to the other
  void transferTask(
      String taskName, String oldTaskListName, String newTaskListName) {
    // Check if task exists in old list
    if (taskExists(taskName, oldTaskListName)) {
      // Get task object from old list
      Task task = taskLists
          .where((taskList) => taskList.name == oldTaskListName)
          .first
          .tasks
          .where((task) => task.name == taskName)
          .first;

      // Delete task in old list
      deleteTask(taskName, oldTaskListName);

      // Add task to new list
      addTask(
        taskName: taskName,
        taskListName: newTaskListName,
        completed: task.completed,
      );

      // Notify Listeners
      notifyListeners();
    }
  }

  //
  // Task List Operations
  //

  // Function to add a new task list
  void addTaskList(String taskListName) {
    // Check if a list with the same name exists
    if (!taskListExists(taskListName)) {
      // Add the task list
      taskLists.add(TaskList(taskListName, []));

      // Save data to local database
      saveDataToDevice();

      // Notify listeners
      notifyListeners();
    }
  }

  // Function to delete a task list
  void deleteTaskList(String taskListName) {
    if (taskListExists(taskListName) && taskLists.length > 1) {
      // Check if this task list is also the one being viewed
      if (taskListName == currentTaskListName) {
        // Set the current task list to any other task list
        setCurrentTaskList(taskLists
            .firstWhere((taskList) => taskList.name != taskListName)
            .name);
      }

      // Remove the task list
      taskLists.removeWhere((taskList) => taskList.name == taskListName);

      // Save data to local database
      saveDataToDevice();

      // Notify listeners
      notifyListeners();
    }
  }

  // Function to trigger deleteAllCompletedTasks in the respective task list
  void deleteAllCompletedTasks(String taskListName) {
    // Getting the appropriate task list.
    int taskListIndex =
        taskLists.indexWhere((taskList) => taskList.name == taskListName);

    // Calling the function
    taskLists[taskListIndex].deleteAllCompletedTasks();

    // Save data to local database
    saveDataToDevice();

    // Notify listeners
    notifyListeners();
  }

  // Function to check if a task list already exists by name
  bool taskListExists(String taskListName) {
    return taskLists.indexWhere((taskList) => taskList.name == taskListName) !=
        -1;
  }

  // Function to get the viewing tasklist
  TaskList getCurrentTaskList() {
    return taskLists
        .firstWhere((taskList) => taskList.name == currentTaskListName);
  }

  // Function to set the viewing tasklist by name
  void setCurrentTaskList(String listName) {
    if (taskLists.indexWhere((taskList) => taskList.name == listName) != -1) {
      currentTaskListName = listName;

      notifyListeners();
    }
  }

//
// Data parsing operations
//

  // To convert the data to a json map structure
  Map<String, dynamic> toJson() {
    return {
      "taskLists": taskLists.map((taskList) => taskList.toJson()).toList(),
    };
  }

  // To load data from json string
  void fromJson(Map<String, dynamic> jsonData) {
    // Loading the Map structure for taskLists
    List<dynamic> taskListsJson = jsonData["taskLists"];

    // Using the loaded Map structure to create TaskList objects
    taskLists = taskListsJson
        .map((jsonTaskList) => TaskList.fromJson(jsonTaskList))
        .toList();
  }

//
// Data Persistance operations
//

  // Function to save data to local storage
  void saveDataToDevice() {
    // Encode data to string
    String data = jsonEncode(toJson());

    // Store data
    localDatabase.put("JSON_TASKS_DATA", data);
  }

  void getDataFromDevice() {
    // Get data
    String data = localDatabase.get("JSON_TASKS_DATA");

    // Decode data to Map
    Map<String, dynamic> structuredData = jsonDecode(data);

    // Load the data
    fromJson(structuredData);
  }
}
