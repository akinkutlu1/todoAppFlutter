import 'package:flutter/material.dart';
import 'package:todoapp0/model/task_model.dart';
import 'package:todoapp0/service/task_service.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({super.key, required this.task});
  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    String imagePath;
    switch (task.type) {
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
      color: task.isCompleted == true ? Colors.grey[300] : Colors.white,
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
                    task.title ?? '',
                    style: TextStyle(
                      decoration: (task.isCompleted ?? false)
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 5),
                  Text(
                    task.description ?? '',
                    style: TextStyle(
                      decoration: (task.isCompleted ?? false)
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: task.isCompleted ?? false,
              onChanged: (val) async {
                if (val == null) return;
                final TaskService taskService = TaskService();
                await taskService.updateTaskStatus(task, val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
