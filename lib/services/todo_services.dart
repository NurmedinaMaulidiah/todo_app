import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_models.dart';

class TodoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream semua todo berdasarkan userId
  Stream<List<Todo>> getTodos(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('todos')
        .orderBy('title')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Todo.fromMap(doc.data(), doc.id)).toList());
  }

  // Tambah todo
  Future<void> addTodo(String userId, String title) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('todos')
        .add({'title': title, 'isDone': false});
  }

  // Update todo
  Future<void> updateTodo(String userId, Todo todo) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todo.id)
        .update(todo.toMap());
  }

  // Hapus todo
  Future<void> deleteTodo(String userId, String todoId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todoId)
        .delete();
  }
}