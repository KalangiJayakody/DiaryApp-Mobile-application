import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {
  final date;
  final email;
  final task;
  final done;
  final dateString;

  ToDo(
      {required this.date,
      required this.email,
      required this.task,
      required this.done,
      required this.dateString});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'date': date,
      'task': task,
      'done': done,
      'dateString': dateString
    };
  }

  ToDo.fromMap(Map<String, dynamic> diaryMap)
      : email = diaryMap["email"],
        date = diaryMap["date"],
        task = diaryMap["task"],
        done = diaryMap["done"],
        dateString = diaryMap["dateString"];

  ToDo.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : email = doc.data()!["email"],
        date = doc.data()!["date"],
        task = doc.data()!["task"],
        done = doc.data()!["done"],
        dateString = doc.data()!["dateString"];
}
