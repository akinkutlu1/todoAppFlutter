import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp0/model/task_model.dart';

class TaskService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // ✅ Yeni görev oluştur
  Future<void> createTask(TaskModel task) async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) {
        throw Exception("Kullanıcı oturumu açık değil.");
      }

      await firestore
          .collection("users")
          .doc(userId)
          .collection("tasks")
          .add(task.toJson());
    } catch (e) {
      print("Görev eklenirken hata oluştu: $e");
    }
  }

  // ✅ Kullanıcının tüm görevlerini getir (anlık olarak)
  Stream<List<TaskModel>> getTasks() {
    final userId = auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("Kullanıcı oturumu açık değil.");
    }

    return firestore
        .collection("users")
        .doc(userId)
        .collection("tasks")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromJson(doc.data()))
            .toList());
  }

  // ✅ Görev güncelle
  Future<void> updateTask(String taskId, TaskModel updatedTask) async {
    final userId = auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("Kullanıcı oturumu açık değil.");
    }

    await firestore
        .collection("users")
        .doc(userId)
        .collection("tasks")
        .doc(taskId)
        .update(updatedTask.toJson());
  }

  // ✅ Görev sil
  Future<void> deleteTask(String taskId) async {
    final userId = auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("Kullanıcı oturumu açık değil.");
    }

    await firestore
        .collection("users")
        .doc(userId)
        .collection("tasks")
        .doc(taskId)
        .delete();
  }

  Future<void> updateTaskStatus(TaskModel task, bool isDone) async {
  final userId = auth.currentUser?.uid;
  if (userId == null) return;

  final query = await firestore
      .collection("users")
      .doc(userId)
      .collection("tasks")
      .where("title", isEqualTo: task.title)
      .where("description", isEqualTo: task.description)
      .limit(1)
      .get();

  if (query.docs.isNotEmpty) {
    await firestore
        .collection("users")
        .doc(userId)
        .collection("tasks")
        .doc(query.docs.first.id)
        .update({'isComplated': isDone});
  }
}

}
