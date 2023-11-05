import 'package:flutter/material.dart';
import 'package:todo_list_app/widget/home.dart';
import 'package:todo_list_app/utils/task_shared_preference.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}


class _CreateTaskState extends State<CreateTask> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();

  String _taskName = "";
  String? _taskDescription;
  DateTime? _pickDate;

  @override
  Widget build(BuildContext context) {
    
    return AlertDialog(
      backgroundColor: Colors.cyan[200],
      title: Text('Create task'),
      content: Container(
        height: 200,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(
                  label: Text('Task'), hintText: "Go for groceries"),
              onSubmitted: (value) {
                setState(() {
                  _taskName = value;
                  print(_taskName);
                });
              },
            ),
            TextField(
              controller: _taskDescriptionController,
              decoration: InputDecoration(
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
                    decoration: InputDecoration(
                      label: Text('Due Date'),
                      hintText: "Enter Date",
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        _pickDate = DateTime.tryParse(value)!;
                        print("Date picked: "+ _pickDate.toString());
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? _futurePickedDate;
                    _futurePickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2500),
                    );
                    setState(() {
                      _pickDate = _futurePickedDate!;
                      _dateController.text = _pickDate.toString();
                      print("Date picked: "+ _pickDate.toString());
                    });
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
            child: Text('Cancel')),
        TextButton(
          // todo add bloc here, event
            onPressed: () async{
              _taskName = _taskNameController.text;
              _taskDescription = _taskDescriptionController.text;
              _pickDate = DateTime.parse(_dateController.text);
              await TaskPreference.saveTask(taskName: _taskName,taskDescription: _taskDescription, createdTime: DateTime.now(), dueTime: _pickDate!);
              Navigator.pop(context, 'Save');
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Home()));
            },
            child: Text('Save')),
      ],
    );
  }
}
