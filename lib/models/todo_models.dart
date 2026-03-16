// class Todo {
//   String id;
//   String title;
//   bool isDone;

//   Todo({
//     required this.id,
//     required this.title,
//     this.isDone = false,
//   });

//   factory Todo.fromMap(Map<String, dynamic> data, String documentId) {
//     return Todo(
//       id: documentId,
//       title: data['title'] ?? '',
//       isDone: data['isDone'] ?? false,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'isDone': isDone,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String title;
  bool isDone;
  DateTime? dueDate;

  Todo({
    required this.id,
    required this.title,
    this.isDone = false,
    this.dueDate,
  });

  factory Todo.fromMap(Map<String, dynamic> data, String documentId) {
    return Todo(
      id: documentId,
      title: data['title'] ?? '',
      isDone: data['isDone'] ?? false,
      dueDate: data['dueDate'] != null
          ? (data['dueDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
    };
  }
}