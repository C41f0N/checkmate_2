import 'package:checkmate_2/data_ops/task_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTaskDialogue extends StatefulWidget {
  const AddTaskDialogue({super.key});

  @override
  State<AddTaskDialogue> createState() => _AddTaskDialogueState();
}

class _AddTaskDialogueState extends State<AddTaskDialogue> {
  String? errorText;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDatabase>(builder: (context, database, child) {
      return AlertDialog(
          title: const Text(
            "Add Task",
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),

                // Enter Task Name
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    label: const Text("Task Name"),
                    errorText: errorText,
                  ),
                ),

                // Add task button
                ElevatedButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        print("Here");
                        if (!database.taskExists(
                            controller.text, database.currentTaskListName)) {
                          setState(() {
                            errorText = null;
                          });
                          database.addTask(
                              controller.text, database.currentTaskListName);
                          Navigator.of(context).pop();
                        } else {
                          setState(() {
                            errorText = "Task name already exists.";
                          });
                        }
                      }
                    },
                    child: const Text("Add")),
              ],
            ),
          ));
    });
  }
}
