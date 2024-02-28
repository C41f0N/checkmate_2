import 'package:auto_size_text/auto_size_text.dart';
import 'package:checkmate_2/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
  });

  final Task task;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            children: [
              Checkbox(
                  value: task.completed,
                  onChanged: (x) {
                    onTap!();
                  }),
              Flexible(
                child: AutoSizeText(
                  task.name,
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha(task.completed ? 175 : 255),
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
