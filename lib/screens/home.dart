import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todoapp0/constants/color.dart';
import 'package:todoapp0/constants/tasktype.dart';
import 'package:todoapp0/model/task_model.dart';
import 'package:todoapp0/screens/add_new_task.dart';
import 'package:todoapp0/service/auth.dart';
import 'package:todoapp0/service/task_service.dart';
import 'package:todoapp0/todoitem.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Auth authService = Auth();
  final TaskService taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: HexColor(backgroundColor),
          body: Column(
            children: [
              // Üst başlık
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
                            "July 9, 2025",
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
                            child: Text(
                              "My Todo List",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
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
                          // çıkış yönlendirmesi buraya eklenebilir
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

              // Firestore'dan görevleri çek ve listele
              Expanded(
                child: StreamBuilder<List<TaskModel>>(
                  stream: taskService.getTasks(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("Henüz görev yok."));
                    }

                    final allTasks = snapshot.data!;
                    final List<TaskModel> todo = allTasks
                        .where((task) => task.isComplated == false)
                        .toList();
                    final List<TaskModel> completed = allTasks
                        .where((task) => task.isComplated == true)
                        .toList();

                    return Column(
                      children: [
                        // TO DO
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: ListView.builder(
                              itemCount: todo.length,
                              itemBuilder: (context, index) {
                                return TodoItem(task: todo[index]);
                              },
                            ),
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Completed",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),

                        // COMPLETED
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: ListView.builder(
                              itemCount: completed.length,
                              itemBuilder: (context, index) {
                                return TodoItem(task: completed[index]);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Yeni görev ekle butonu
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor("#4A3780"),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddNewTaskScreen(),
                    ),
                  );
                },
                child: const Text("Add New Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
