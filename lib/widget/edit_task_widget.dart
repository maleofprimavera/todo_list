import 'dart:convert';

import 'package:flutter/material.dart';

import 'home.dart';
import '../model/task_model.dart';
import '../utils/task_shared_preference.dart';

class EditTask extends StatefulWidget {
  final String keyTask;
  const EditTask({super.key, required this.keyTask});

  @override
  State<EditTask> createState() => _EditTaskState(keyTask: keyTask);
}

late String _taskName;
String? _taskDescription;
late DateTime _pickDate;
late Task task;

class _EditTaskState extends State<EditTask> {
  final String keyTask;
  _EditTaskState({required this.keyTask});
  late Future<dynamic> _taskFuture;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _taskFuture = fetchData(keyTask);
  }
  Future<dynamic> fetchData(String keyTask) async {
    return TaskPreference.getTaskWithKey(keyTask: keyTask);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _taskFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // or a loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No data found');
        } else {
          task = snapshot.data!;
          _dateController.text = task!.dueTime.toString();
          _taskNameController.text = task!.taskName;
          (task!.taskDescription != null)
              ? _taskDescriptionController.text = task!.taskDescription!
              : task!.taskDescription = null;
          return AlertDialog(
            backgroundColor: Colors.cyan[200],
            title: const Text('Edit task'),
            content: Container(
              height: 200,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _taskNameController,
                    decoration: const InputDecoration(
                        label: Text('Task Name'), hintText: "Go for groceries"),
                    onSubmitted: (value) {
                      setState(() {
                        _taskName = value;
                        print(_taskName);
                      });
                    },
                  ),
                  TextField(
                    controller: _taskDescriptionController,
                    decoration: const InputDecoration(
                        label: Text('Description'),
                        hintText: "Banana, Apple, Cider Vinegar"),
                    onSubmitted: (value) {
                      setState(() {
                        _taskDescription = value;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.datetime,
                          controller: _dateController,
                          decoration: const InputDecoration(
                            label: Text('Due Date'),
                            hintText: "Enter Date",
                          ),
                          onSubmitted: (value) {
                            _dateController.text = value;
                            print("Date picked: " + _dateController.text);
                            // setState(() {
                            //   _dateController.text= value;
                            //   print("Date picked: " + _dateController.text);
                            // });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? _futurePickedDate;
                          _futurePickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2500),
                          );
                          _dateController.text = _futurePickedDate!.toString();
                          print("Date picked: " + _dateController.text);
                          // setState(() {
                          //   // _pickDate = _futurePickedDate!;
                          //   _dateController.text = _futurePickedDate!.toString();
                          //   print("Date picked: " + _dateController.text);
                          // });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    TaskPreference.deleteTask(keyTask);
                    Navigator.pop(context, 'Delete');
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  },
                  child: const Text('Delete')),
              TextButton(
                onPressed: () async {
                  _taskName = _taskNameController.text;
                  _taskDescription = _taskDescriptionController.text;
                  _pickDate = DateTime.parse(_dateController.text);
                  await TaskPreference.editTask(
                      taskName: _taskName,
                      taskDescription: _taskDescription,
                      dueTime: _pickDate!,
                      keyTask: keyTask);
                  Navigator.pop(context, 'Save Edit');
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => const Home()));
                },
                child: const Text('Save Edit'),
              ),
            ],
          );
        }
        // Rest of your build method using the 'task' variable...
      },
    );
  }
}
