import 'package:flutter/material.dart';
import 'package:todoapp0/constants/tasktype.dart';
import 'package:todoapp0/model/task_model.dart';
import 'package:todoapp0/service/task_service.dart';

class TodoItem extends StatefulWidget {
  const TodoItem({super.key, required this.task});
  final TaskModel task;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late bool isChecked;
  final TaskService taskService = TaskService();

  @override
  void initState() {
    super.initState();
    isChecked = widget.task.isComplated ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // Görev tipi string olarak geldiği için enum kontrolü yapamayız
    String imagePath;
    switch (widget.task.type) {
      case 'note':
        imagePath = "lib/assets/images/category_1.png";
        break;
      case 'calendar':
        imagePath = "lib/assets/images/category_2.png";
        break;
      case 'contest':
        imagePath = "lib/assets/images/category_3.png";
        break;
      default:
        imagePath = "lib/assets/images/category_1.png";
    }

    return Card(
      color: widget.task.isComplated == true ? Colors.grey[300] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(imagePath, width: 40, height: 40),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title ?? '',
                    style: TextStyle(
                      decoration: isChecked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.task.description ?? '',
                    style: TextStyle(
                      decoration: isChecked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),

            Checkbox(
              value: isChecked,
              onChanged: (val) async {
                if (val == null) return;

                setState(() {
                  isChecked = val;
                });

                // Firestore’da görevin durumunu güncelle
                await taskService.updateTaskStatus(widget.task, val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
