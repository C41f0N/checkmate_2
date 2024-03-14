import 'package:checkmate_2/data_ops/task_database.dart';
import 'package:checkmate_2/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTaskDialogue extends StatefulWidget {
  const EditTaskDialogue({
    super.key,
    required this.task,
    required this.taskListName,
  });

  final Task task;
  final String taskListName;

  @override
  State<EditTaskDialogue> createState() => _EditTaskDialogueState();
}

class _EditTaskDialogueState extends State<EditTaskDialogue> {
  String? errorText;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.task.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDatabase>(builder: (context, database, child) {
      return AlertDialog(
          title: const Text(
            "Edit Task",
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

                // Edit task button
                ElevatedButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        if (!database.taskExists(
                            controller.text, database.currentTaskListName)) {
                          setState(() {
                            errorText = null;
                          });
                          database.editTask(
                            widget.task.name,
                            controller.text,
                            database.currentTaskListName,
                          );
                          Navigator.of(context).pop();
                        } else {
                          setState(() {
                            errorText = "Task name already exists.";
                          });
                        }
                      }
                    },
                    child: const Text("Edit")),
              ],
            ),
          ));
    });
  }
}
