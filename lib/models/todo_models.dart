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

//utk nyimpan data todo di app, convert data dari firestore ke model, convert model ke map untuk Firestore
//ubah data dari firestore ke model <> model ke firestore biar bisa simpan di firestore dan apk 
import 'package:cloud_firestore/cloud_firestore.dart';

class Todo { //proses nyimpan todo dari firestore
  String id;
  String title;
  bool isDone; //udh kelar atau belum
  DateTime? dueDate;

  Todo({// KONSTRUKTOR TODO
    required this.id,
    required this.title,
    this.isDone = false, //default blm selesai, karena otomatis blm selesai
    this.dueDate,
  });
 // PROSES DARI FIRESTORE KE MODEL
  factory Todo.fromMap(Map<String, dynamic> data, String documentId) {
    return Todo(
      id: documentId, //proses ambil id dll
      title: data['title'] ?? '',
      isDone: data['isDone'] ?? false,
      dueDate: data['dueDate'] != null
          ? (data['dueDate'] as Timestamp).toDate() // konversi Timestamp ke DateTime (biar bisa dipake ke app)
          : null,
    );
  }//time stamp untuk firestore, date time untuk app atau flutter
// PROSES DARI MODEL KE FIRESTORE
  Map<String, dynamic> toMap() {
    return {
      'title': title, // proses simpan title
      'isDone': isDone, //simpan status to do
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null, // proses konversi DateTime ke Timestamp Firestore biar bisa dipake firestore
    };
  }
}