//utk ambil data dan crud  todo dari firebase dan hubungkan firestore dengan apk
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoService {// proses inisialisasi Firestore
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // proses ambil todo / Stream semua todo berdasarkan userId
  Stream<List<Todo>> getTodos(String userId) { //pake stream biar realtime upadte kalo data berubah di firestore
    return _db
        .collection('users')
        .doc(userId)
        .collection('todos')
        .orderBy('dueDate', descending: false) //SORTING by DEADLINE
        .snapshots()
        .map((snapshot) =>
        // proses ubah snapshot Firestore ke list Todo model
            snapshot.docs.map((doc) => Todo.fromMap(doc.data(), doc.id)).toList());
  }

  // fungsi Tambah todo
  Future<void> addTodo(String userId, String title, DateTime? dueDate) async {
  await _db //proses tambah todo baru ke firestore
      .collection('users')
      .doc(userId)
      .collection('todos')
      .add({
        'title': title,
        'isDone': false, // isDone default false, createdAt pakai serverTimestamp supaya sinkron dengan waktu server
        'createdAt': FieldValue.serverTimestamp(), //FieldValue.serverTimestamp() dipakai supaya waktu data selalu sinkron dan konsisten dari server Firestore, bukan tergantung jam HP user.
        'dueDate': dueDate != null ? Timestamp.fromDate(dueDate) : null,// proses convert DateTime ke Timestamp Firestore
      });
}

  // fungsi update todo sesuai id
  Future<void> updateTodo(String userId, Todo todo) async {
    await _db 
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todo.id)
        .update(todo.toMap());
  }

  // fungsi hapus todo
  Future<void> deleteTodo(String userId, String todoId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todoId)
        .delete();
  }
}