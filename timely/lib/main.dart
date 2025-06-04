import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timely/models/task.dart';

void main() async {

  // Initializes the Hive
  await Hive.initFlutter();
  
  // Register our TaskAdapter
  Hive.registerAdapter(TaskAdapter());

  // Open Hive box
  await Hive.openBox<Task>('taskBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timely',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Your Tasks'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List of Type Options
  final List<String> _types = ["Select Type", "countUp", "countDown", "Time"]; 

  Task? _retrievedTask; // Task? -> Nullable type I assume
  TextEditingController _taskNameController = TextEditingController(); // a 'manager' for a text input field (ex: TextField, TextFormField)
  // So TextField for example is a visible input box where the user types, the Controller is what will hold the text, allowing us to interact with it programmatically
  // TLDR: To read what user typed, set text via code, or react to any text changes in a Flutter TextField, we'll need to use TextEditingController

  @override
  void initState(){
    super.initState();
    _initializeHiveData();
  }

  void _initializeHiveData(){ // Handle hive operations upon initializing
    final taskBox = Hive.box<Task>('taskBox');

    // 
    taskBox.put('myFirstTask', Task(title: "Feed the dogs", prio:1));

    _retrievedTask = taskBox.get('myFirstTask');

    print('Retrieve Task in initState: $_retrievedTask');
  }

  @override
  void dispose(){
    _taskNameController.dispose();
    super.dispose();
  }

  // Opens the create task menu
  void _createTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedType = _types[0];
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              title: const Text('Create Task'),
              content: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 300.0,
                height: 200.0,
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Task Name",
                        border: OutlineInputBorder(),
                        hintText: 'Enter Task Name',
                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.3))
                    
                      ),
                    ),

                    DropdownMenu<String>(
                      initialSelection: _types[0],
                      onSelected: (String? newType) {
                        setState(() {
                          selectedType = newType;
                        });

                        
                      },
                      dropdownMenuEntries: _types.map((type) => DropdownMenuEntry(value: type, label: type)).toList(),
                    ),

                    if (selectedType == "countUp") ...[
                      Text("hello")
                    ],
                    Text("Cycle") 
                  ],
                  
                ),
                
              ),
              
              // Creates Task
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CREATE'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           Text("Do I work again?")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: _createTask,
        tooltip: 'Create Task',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


/*

lib

-> views
  -> goals
    -> types
    create_goal.dart
    goal.dart

  -> home
    home.dart

-> widgets
  navbar.dart

main.dart

*/