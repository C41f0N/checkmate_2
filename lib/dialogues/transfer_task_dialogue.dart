import 'package:checkmate_2/data_ops/task_database.dart';
import 'package:checkmate_2/models/task_list_model.dart';
import 'package:checkmate_2/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransferTaskDialogue extends StatefulWidget {
  const TransferTaskDialogue({super.key, required this.task});

  final Task task;

  @override
  State<TransferTaskDialogue> createState() => _TransferTaskDialogueState();
}

class _TransferTaskDialogueState extends State<TransferTaskDialogue> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDatabase>(
      builder: (BuildContext context, TaskDatabase database, Widget? child) {
        List<TaskList> taskLists = database.taskLists;

        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          title: const Text("Transfer Task"),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Text(
                    "Select a list to transfer to",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color.fromARGB(255, 20, 20, 20),
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                        itemCount: taskLists.length,
                        itemBuilder: (context, index) {
                          return database.currentTaskListName !=
                                  taskLists[index].name
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      database.transferTask(
                                        widget.task.name,
                                        database.currentTaskListName,
                                        taskLists[index].name,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.grey[900],
                                      ),
                                      height: 60,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            taskLists[index].name,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
