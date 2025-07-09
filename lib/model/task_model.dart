class TaskModel {
  final String? type;
  final String? title;
  final String? description;
  final bool? isComplated;

  TaskModel({
    required this.type,
    required this.title,
    required this.description,
    required this.isComplated,
  });

  // Firestore'dan gelen veriyi modele çevirme
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      type: json['type'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      isComplated: json['isComplated'] as bool? ?? false,
    );
  }

  // Modele göre Firestore'a veri gönderme
  Map<String, dynamic> toJson() {
    return {
      'type': type ?? '',
      'title': title ?? '',
      'description': description ?? '',
      'isComplated': isComplated ?? false,
    };
  }
}
