import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/widget/home.dart';
import 'package:todo_list_app/model/task_model.dart';
import 'package:todo_list_app/utils/task_shared_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TaskPreference.init();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ToDo List Demo',
      theme: ThemeData(
      ),
      home:const Home(),
    );
  }
}