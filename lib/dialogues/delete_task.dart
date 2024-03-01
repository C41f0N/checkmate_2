import 'package:flutter/material.dart';

class DeleteTaskDialogue extends StatelessWidget {
  const DeleteTaskDialogue({
    super.key,
    required this.taskName,
    required this.deleteTaskMethod,
  });

  final String taskName;
  final void Function() deleteTaskMethod;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure you want to delete the task $taskName?"),
      actions: [
        ElevatedButton(
          onPressed: () {
            deleteTaskMethod();
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
