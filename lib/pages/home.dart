import 'package:checkmate_2/data_ops/task_database.dart';
import 'package:checkmate_2/dialogues/add_task.dart';
import 'package:checkmate_2/dialogues/add_task_list.dart';
import 'package:checkmate_2/dialogues/delete_all_completed_tasks.dart';
import 'package:checkmate_2/dialogues/delete_task.dart';
import 'package:checkmate_2/dialogues/delete_task_list.dart';
import 'package:checkmate_2/dialogues/task_card_options.dart';
import 'package:checkmate_2/models/task_list_model.dart';
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
        TaskList taskList = database.getCurrentTaskList();
        database.getDataFromDevice();

        return Scaffold(
          // AppBar
          appBar: AppBar(
            title: const Text("C H E C K M A T E"),
            actions: [
              PopupMenuButton(
                color: Theme.of(context).colorScheme.secondary,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: const Text("Remove Completed Tasks"),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => DeleteAllCompletedTasksDialogue(
                            taskListName: database.currentTaskListName,
                            deleteAllCompletedTasksMethod: () {
                              database.deleteAllCompletedTasks(
                                  database.currentTaskListName);
                            },
                          ),
                        );
                      },
                    ),
                  ];
                },
              ),
            ],
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

                const SizedBox(
                  height: 10,
                ),

                // Check Lists
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    itemCount: database.taskLists.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        // To select the task list to view
                        onTap: () {
                          database.setCurrentTaskList(
                              database.taskLists[index].name);
                        },

                        // To delete the task list
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: ((context) => DeleteTaskListDialogue(
                                  taskListName: database.taskLists[index].name,
                                  deleteTaskListMethod: () {
                                    database.deleteTaskList(
                                        database.taskLists[index].name);
                                  },
                                )),
                          );
                        },

                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: database.currentTaskListName ==
                                    database.taskLists[index].name
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            database.taskLists[index].name,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Add more lists button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => const AddTaskListDialogue());
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
                database.toggleTask(taskList.name, taskList.tasks[index].name);
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: ((context) => TaskCardOptions(
                        task: taskList.tasks[index],
                      )),
                );
              },
            ),
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddTaskDialogue(),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
