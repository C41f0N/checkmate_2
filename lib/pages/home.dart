import 'package:checkmate_2/data_ops/task_database.dart';
import 'package:checkmate_2/models/task_list_model.dart';
import 'package:checkmate_2/models/task_model.dart';
import 'package:checkmate_2/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDatabase>(
      builder: (context, database, child) {
        database.createTaskList("First Task List");

        TaskList taskList = database.taskLists[0];
        taskList.addTask("task 1");
        taskList.addTask("task 2");
        taskList.addTask("task 3");

        return Scaffold(
          // AppBar
          appBar: AppBar(
            title: const Text("C H E C K M A T E"),
          ),

          // Drawer
          drawer: const Drawer(),

          body: ListView.builder(
            itemCount: taskList.tasks.length,
            itemBuilder: (context, index) => TaskCard(
              task: taskList.tasks[index],
              onTap: () {
                print("pressed");
                database.toggleTask(taskList.name, taskList.tasks[index].name);
              },
            ),
          ),
        );
      },
    );
  }
}
