import 'package:checkmate_2/data_ops/task_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTaskListDialogue extends StatefulWidget {
  const AddTaskListDialogue({super.key});

  @override
  State<AddTaskListDialogue> createState() => _AddTaskListState();
}

class _AddTaskListState extends State<AddTaskListDialogue> {
  String? errorText;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDatabase>(builder: (context, database, child) {
      return AlertDialog(
          title: const Text(
            "Add Task List",
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
                    label: const Text("List Name"),
                    errorText: errorText,
                  ),
                ),

                // Add task button
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      if (!database.taskListExists(controller.text)) {
                        setState(() {
                          errorText = null;
                        });
                        database.addTaskList(controller.text);
                        Navigator.of(context).pop();
                      } else {
                        setState(() {
                          errorText = "List name already exists.";
                        });
                      }
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          ));
    });
  }
}
