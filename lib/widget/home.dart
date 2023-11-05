import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_list_app/utils/task_shared_preference.dart';
import 'package:todo_list_app/widget/create_task_widget.dart';

import 'package:todo_list_app/widget/task_widget.dart';

import '../model/task_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:  () async {
      // Prevent the Home page from being popped.
      return false;
    },
      child: Scaffold(
        appBar: AppBar(
          title: Text('TODO LIST'),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Map<String, Task>>>(future: TaskPreference.getAllTask(),
            builder: (BuildContext context, AsyncSnapshot<List<Map<String, Task>>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          } else{
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: const TextStyle(fontSize: 18),
                ),
              );
              // if we got our data
            }
            else {
              List<Map<String, Task>> list = snapshot.data!;
              print(snapshot.data?.length);
              return ListView.builder (
                itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                  Task task = list!.elementAt(index).values.elementAt(0);
                  print(task.toJson().toString());
                  return TaskWidget(task: task, keyTask: list!.elementAt(index).keys.first,);
                  });
            }
          }
        }),
        floatingActionButton: FloatingActionButton(
            onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return CreateTask();
                }),
            child: Icon(Icons.add)),
      ),
    );
  }
}
