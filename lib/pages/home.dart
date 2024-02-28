import 'package:checkmate_2/data_ops/task_database.dart';
import 'package:checkmate_2/models/task_list_model.dart';
import 'package:checkmate_2/models/task_model.dart';
import 'package:checkmate_2/widgets/task_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        TaskList taskList = database.taskLists[0];
        return Scaffold(
          // AppBar
          appBar: AppBar(
            title: const Text("C H E C K M A T E"),
          ),

          // Drawer
          drawer: Drawer(
            backgroundColor:
                Theme.of(context).colorScheme.background.withAlpha(175),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Drawer Header
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomLeft,
                    child: const Text(
                      "C H E C K M A T E",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),

                // Check Lists
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    itemCount: database.taskLists.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(database.taskLists[index].name),
                      );
                    },
                  ),
                ),

                // Add more lists button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      database.addTaskList("Another Task List");
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),
          ),

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
