import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class Diary {
  final email;
  final date;
  final description;
  final mood;
  final dateString;

  Diary(
      {required this.email,
      required this.date,
      required this.description,
      required this.mood,
      required this.dateString});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'date': date,
      'description': description,
      'mood': mood,
      'dateString': dateString
    };
  }

  Diary.fromMap(Map<String, dynamic> diaryMap)
      : email = diaryMap["email"],
        date = diaryMap["date"],
        description = diaryMap["description"],
        mood = diaryMap["mood"],
        dateString = diaryMap["dateString"];

  Diary.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : email = doc.data()!["email"],
        date = doc.data()!["date"],
        description = doc.data()!["description"],
        mood = doc.data()!["mood"],
        dateString = doc.data()!["dateString"];
}
