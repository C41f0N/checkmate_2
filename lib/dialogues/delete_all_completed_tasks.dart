import 'package:flutter/material.dart';

class DeleteAllCompletedTasksDialogue extends StatelessWidget {
  const DeleteAllCompletedTasksDialogue({
    super.key,
    required this.taskListName,
    required this.deleteAllCompletedTasksMethod,
  });

  final String taskListName;
  final void Function() deleteAllCompletedTasksMethod;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          "Are you sure you want to delete all completed tasks in '$taskListName'?"),
      actions: [
        ElevatedButton(
          onPressed: () {
            deleteAllCompletedTasksMethod();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.25),
          ),
          child: const Text("Yes"),
        ),
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No")),
      ],
    );
  }
}
