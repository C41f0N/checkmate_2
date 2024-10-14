import 'package:checkmate_2/data_ops/task_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDatabase>(builder: (context, database, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("S E T T I N G S"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Add new tasks to the lists' end",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Switch(
                        value: database.addTasksToEnd,
                        onChanged: (value) {
                          database.setAddTasksToEnd(value);
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
