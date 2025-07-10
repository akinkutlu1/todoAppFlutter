class TaskModel {
  final String? id; // Firestore document ID
  final String? title;
  final String? description;
  final String? type;
  final bool? isCompleted;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.type,
    this.isCompleted,
  });

  // Firestore'a veri gönderirken
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'isCompleted': isCompleted,
    };
  }

  // Firestore'dan veri çekerken
  factory TaskModel.fromJson(Map<String, dynamic> json, [String? docId]) {
    return TaskModel(
      id: docId,
      title: json['title'],
      description: json['description'],
      type: json['type'],
      isCompleted: json['isCompleted'],
    );
  }
}
