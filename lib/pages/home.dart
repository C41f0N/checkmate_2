import 'dart:io';

import 'package:checkmate_2/data_ops/task_database.dart';
import 'package:checkmate_2/dialogues/add_task.dart';
import 'package:checkmate_2/dialogues/add_task_list.dart';
import 'package:checkmate_2/dialogues/delete_all_completed_tasks.dart';
import 'package:checkmate_2/dialogues/delete_task.dart';
import 'package:checkmate_2/dialogues/delete_task_list.dart';
import 'package:checkmate_2/dialogues/edit_task_dialogue.dart';
import 'package:checkmate_2/dialogues/task_card_options.dart';
import 'package:checkmate_2/dialogues/transfer_task_dialogue.dart';
import 'package:checkmate_2/models/task_list_model.dart';
import 'package:checkmate_2/pages/settings.dart';
import 'package:checkmate_2/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool reorderMode;

  @override
  void initState() {
    reorderMode = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDatabase>(
      builder: (context, database, child) {
        TaskList taskList = database.getCurrentTaskList();
        database.getDataFromDevice();

        return Scaffold(
          // AppBar
          appBar: AppBar(
            automaticallyImplyLeading: !reorderMode,
            title: Text(!reorderMode ? "C H E C K M A T E" : "R E O R D E R"),
            actions: [
              !reorderMode
                  ? PopupMenuButton(
                      color: Theme.of(context).colorScheme.secondary,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: const Text("Remove Completed Tasks"),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    DeleteAllCompletedTasksDialogue(
                                  taskListName: database.currentTaskListName,
                                  deleteAllCompletedTasksMethod: () {
                                    database.deleteAllCompletedTasks(
                                        database.currentTaskListName);
                                  },
                                ),
                              );
                            },
                          ),
                          PopupMenuItem(
                            child: const Text("Reorder Tasks"),
                            onTap: () {
                              if (Platform.isAndroid || Platform.isIOS) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Tap and hold tasks to reorder.",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              setState(() {
                                reorderMode = true;
                              });
                            },
                          ),
                          PopupMenuItem(
                            child: const Text("Settings"),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SettingsPage(),
                                ),
                              );
                            },
                          ),
                        ];
                      },
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          reorderMode = false;
                        });
                      },
                      icon: const Icon(Icons.done),
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

          body: !reorderMode
              ? ListView.builder(
                  itemCount: taskList.tasks.length,
                  itemBuilder: (context, index) => TaskCard(
                    task: taskList.tasks[index],
                    onTap: () {
                      database.toggleTask(
                          taskList.name, taskList.tasks[index].name);
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: ((context) => TaskCardOptions(
                              task: taskList.tasks[index],
                              onEditTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => EditTaskDialogue(
                                    task: taskList.tasks[index],
                                    taskListName: taskList.name,
                                  ),
                                ).then(
                                  (value) => Navigator.of(context).pop(),
                                );
                              },
                              onDeleteTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => DeleteTaskDialogue(
                                    taskName: taskList.tasks[index].name,
                                    deleteTaskMethod: () {
                                      database.deleteTask(
                                        taskList.tasks[index].name,
                                        taskList.name,
                                      );
                                    },
                                  ),
                                ).then(
                                  (value) => Navigator.of(context).pop(),
                                );
                              },
                              onTransferToTasklistTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => TransferTaskDialogue(
                                    task: taskList.tasks[index],
                                  ),
                                ).then(
                                  (value) => Navigator.of(context).pop(),
                                );
                              },
                            )),
                      );
                    },
                    reorderMode: false,
                  ),
                )
              : ReorderableListView.builder(
                  onReorder: ((oldIndex, newIndex) {
                    database.reorderTask(
                      taskListName: database.currentTaskListName,
                      oldIndex: oldIndex,
                      newIndex: newIndex,
                    );
                  }),
                  itemBuilder: (BuildContext context, int index) => TaskCard(
                    key: ValueKey(taskList.tasks[index]),
                    task: taskList.tasks[index],
                    onTap: () {
                      database.toggleTask(
                          taskList.name, taskList.tasks[index].name);
                    },
                    onLongPress: () {},
                    reorderMode: true,
                  ),
                  itemCount: taskList.tasks.length,
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
