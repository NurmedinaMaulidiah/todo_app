class Todo {
  String id;
  String title;
  bool isDone;

  Todo({
    required this.id,
    required this.title,
    this.isDone = false,
  });

  factory Todo.fromMap(Map<String, dynamic> data, String documentId) {
    return Todo(
      id: documentId,
      title: data['title'] ?? '',
      isDone: data['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
    };
  }
}