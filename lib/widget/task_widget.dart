import 'package:flutter/material.dart';
import 'package:todo_list_app/utils/task_shared_preference.dart';
import 'package:todo_list_app/widget/edit_task_widget.dart';

import '../model/task_model.dart';

class TaskWidget extends StatefulWidget{
  // final String taskName  ;
  // final String? taskDescription;
  // final DateTime dueTime;
  // final String keyTask;

  // TaskWidget(
  // {required this.taskName, this.taskDescription, required this.dueTime, required this.keyTask}); //

  final Task task;
  final String keyTask;

  TaskWidget({required this.task, required this.keyTask});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(6)),
        height: 80,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: ListTile(
            onLongPress: () => showDialog(
                context: context,
                builder: (context) {
                  return EditTask(keyTask: widget.keyTask);
                }),
            title: Text('${widget.task.taskName}'),
            subtitle: Text('${widget.task.taskDescription}'),
            leading: Text('${widget.task.dueTime.toString()}'),
            trailing: Checkbox(
              value: widget.task.isDone,
              onChanged: (bool? checked) {
                setState(() {
                  widget.task.isDone = checked!;
                  TaskPreference.checkTask(keyTask: widget.keyTask, isDone: widget.task.isDone);
                });
              },
            )));
  }
}
