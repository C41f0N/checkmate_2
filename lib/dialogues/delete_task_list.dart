import 'package:flutter/material.dart';

class DeleteTaskListDialogue extends StatelessWidget {
  const DeleteTaskListDialogue({
    super.key,
    required this.taskListName,
    required this.deleteTaskListMethod,
  });

  final String taskListName;
  final void Function() deleteTaskListMethod;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure you want to delete the list '$taskListName'?"),
      actions: [
        ElevatedButton(
          onPressed: () {
            deleteTaskListMethod();
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
