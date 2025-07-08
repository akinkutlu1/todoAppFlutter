import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todoapp0/constants/color.dart';
import 'package:todoapp0/constants/tasktype.dart';
import 'package:todoapp0/model/task.dart';
import 'package:todoapp0/screens/add_new_task.dart';
import 'package:todoapp0/service/auth.dart';
import 'package:todoapp0/todoitem.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  State<HomeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<HomeScreen> {
  //List<String> todo = ["Study lessons", "Run 5k", "Go to party"];
  //List<String> Complated = ["Game meetup", "Take out trash"];
  List<Task> todo = [
    Task(
      type: TaskType.note,
      title: "Study lessons",
      description: "Study comp117",
      isComplated: false,
    ),
    Task(
      type: TaskType.calendar,
      title: "Go to party",
      description: "Attend to party",
      isComplated: false,
    ),
    Task(
      type: TaskType.contest,
      title: "Run 5k",
      description: "run 5 kilometres",
      isComplated: false,
    ),
  ];
  List<Task> complated = [
    Task(
      type: TaskType.calendar,
      title: "Go to party",
      description: "Attend to party",
      isComplated: false,
    ),
    Task(
      type: TaskType.contest,
      title: "Run 5k",
      description: "run 5 kilometres",
      isComplated: false,
    ),
  ];

  void addNewTask(Task newTask) {
    setState(() {
      todo.add(newTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    Auth authService = Auth();
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: HexColor(backgroundColor),
          body: Column(
            children: [
              Container(
                width: deviceWidth,
                height: deviceHeight / 3,
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  image: DecorationImage(
                    image: AssetImage("lib/assets/images/header.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            "June 27, 2025",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "My Todo List",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 7,
                      right: 5,
                      child: ElevatedButton(
                        onPressed: () async {
                          await authService.signOut();
                          // çıkış işlemi buraya yazılacak
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.3),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("LogOut"),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: todo.length,
                      itemBuilder: (context, index) {
                        return TodoItem(task: todo[index]);
                      },
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Complated",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: complated.length,
                      itemBuilder: (context, index) {
                        return TodoItem(task: todo[index]);
                      },
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor("#4A3780"), // Arka plan rengi
                  foregroundColor: Colors.white, // Yazı rengi
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddNewTaskScreen(
                        addNewTask: (newTask) => addNewTask(newTask),
                      ),
                    ),
                  );
                },
                child: Text("Add New Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
