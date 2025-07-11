class TaskModel {
  final String? id; // ✅ id artık nullable

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

  factory TaskModel.fromJson(Map<String, dynamic> json, String documentId) {
    return TaskModel(
      id: documentId,
      title: json['title'],
      description: json['description'],
      type: json['type'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'isCompleted': isCompleted,
    };
  }
}
