import 'package:auto_size_text/auto_size_text.dart';
import 'package:checkmate_2/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskCardOptions extends StatelessWidget {
  const TaskCardOptions({
    super.key,
    required this.task,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  final Task task;
  final void Function() onEditTap;
  final void Function() onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(10),
      contentPadding: const EdgeInsets.all(10),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: const Color.fromARGB(255, 16, 16, 16),
      title: Container(
        height: 70,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Checkbox(value: task.completed, onChanged: (x) {}),
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
      content: SizedBox(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Edit button
              GestureDetector(
                onTap: () {
                  onEditTap();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 25, 25, 25),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 55,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Edit"),
                      ],
                    ),
                  ),
                ),
              ),

              // Delete button
              GestureDetector(
                onTap: () {
                  onDeleteTap();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 25, 25, 25),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 55,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Delete"),
                      ],
                    ),
                  ),
                ),
              ),

              // Transfer to task list button
              // GestureDetector(
              //   onTap: onTransferToTasklistTap,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: const Color.fromARGB(255, 25, 25, 25),
              //       borderRadius: BorderRadius.circular(30),
              //     ),
              //     width: MediaQuery.of(context).size.width * 0.6,
              //     height: 55,
              //     child: const Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 20.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Icon(Icons.arrow_right_outlined),
              //           SizedBox(
              //             width: 20,
              //           ),
              //           Text("Transfer to another list"),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
