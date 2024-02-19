import 'package:cloud_firestore/cloud_firestore.dart';

class DailyTips {
  final date;
  final email;
  final List tips;

  DailyTips({required this.date, required this.email, required this.tips});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'date': date,
      'tips': tips,
    };
  }

  DailyTips.fromMap(Map<String, dynamic> diaryMap)
      : email = diaryMap["email"],
        date = diaryMap["date"],
        tips = diaryMap["tips"];

  DailyTips.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : email = doc.data()!["email"],
        date = doc.data()!["date"],
        tips = doc.data()!["tips"];
}
