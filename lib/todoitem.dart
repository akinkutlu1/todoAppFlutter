import 'package:flutter/material.dart';
import 'package:todoapp0/model/task_model.dart';
import 'package:todoapp0/service/task_service.dart';

class TodoItem extends StatefulWidget {
  const TodoItem({super.key, required this.task});
  final TaskModel task;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    if (task.id == null) {
      // Eğer id null ise hiçbir şey gösterme
      return const SizedBox.shrink();
    }

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

    // Eğer silme işlemi devam ediyorsa dairesel loading göster
    if (isDeleting) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: SizedBox(
            height: 60,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }

    return Dismissible(
      key: Key(task.id!),
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Silmek istediğinize emin misiniz?'),
            content: const Text('Bu görev kalıcı olarak silinecek.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Sil'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        setState(() {
          isDeleting = true; // silme başlıyor, loading göster
        });

        final taskService = TaskService();

        try {
          await taskService.deleteTask(task.id!);
          // Silmeden sonra 1 saniye bekle
          await Future.delayed(const Duration(seconds: 1));

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${task.title ?? 'Görev'} silindi")),
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Silme işlemi başarısız: $e")),
          );
        }

        if (!mounted) return;
        setState(() {
          isDeleting = false; // işlem bitti, loading kaldır
        });
      },
      child: Card(
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
                  final taskService = TaskService();
                  await taskService.updateTaskStatus(task, val);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
