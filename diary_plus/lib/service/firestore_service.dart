import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_plus/models/daily_tips.dart';
import 'package:diary_plus/models/diary.dart';
import 'package:diary_plus/models/to_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diary_plus/models/user.dart';

class FirestoreService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  ///////////////////////////////////////////////////////////
  final CollectionReference _user =
      FirebaseFirestore.instance.collection('user');

  Future<void> addUser(AppUser userData) async {
    await _user.add(userData.toMap());
  }

  Future<void> deleteUser(String userEmail) async {
    QuerySnapshot snapshot =
        await _user.where('email', isEqualTo: userEmail).get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await _user.doc(doc.id).delete();
    }
  }

  Stream<QuerySnapshot> getCurrentUser() {
    final userEmail = auth.currentUser?.email;
    final user = _user.where('email', isEqualTo: userEmail).snapshots();
    return user;
  }

  /////////////////////////////////////////////////////////////////////
  final CollectionReference day = FirebaseFirestore.instance.collection('day');

  Future<void> addDay(Diary diaryData) async {
    final userEmail = auth.currentUser?.email;
    day.add(diaryData.toMap());
  }

  Future<void> deleteDay(Timestamp date) async {
    final userEmail = auth.currentUser?.email;
    QuerySnapshot snapshot = await day
        .where('date', isEqualTo: date)
        .where('email', isEqualTo: userEmail)
        .get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await day.doc(doc.id).delete();
    }
  }

  Future<void> deleteAllDay(String email) async {
    QuerySnapshot snapshot = await day.where('email', isEqualTo: email).get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await day.doc(doc.id).delete();
    }
  }

  Future<void> updateDay(
    Timestamp date,
    String newMood,
    String newDescription,
  ) async {
    final userEmail = auth.currentUser?.email;
    QuerySnapshot snapshot = await day
        .where('date', isEqualTo: date)
        .where('email', isEqualTo: userEmail)
        .get();

    Map<String, dynamic> updatedFields = {
      'mood': newMood,
      'description': newDescription,
    };

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await day.doc(doc.id).update(updatedFields);
    }
  }

  Stream<QuerySnapshot> getDiary() {
    final userEmail = auth.currentUser?.email;
    final diaries = day
        .where('email', isEqualTo: userEmail)
        .orderBy('date', descending: true)
        .snapshots();
    return diaries;
  }

  Future<List<Diary>> retrieveDiaries() async {
    final userEmail = auth.currentUser?.email;
    QuerySnapshot<Map<String, dynamic>> snapshot = await day
        .where('email', isEqualTo: userEmail)
        .get() as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs
        .map((docSnapshot) => Diary.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Stream<QuerySnapshot> getSelectedDiary(Timestamp dateSelected) {
    final userEmail = auth.currentUser?.email;
    final diarySelected = day
        .where('email', isEqualTo: userEmail)
        .where('date', isEqualTo: dateSelected)
        .snapshots();
    return diarySelected;
  }

  Stream<QuerySnapshot> getSelectedDiaryCalendar(String dateSelected) {
    final userEmail = auth.currentUser?.email;
    final diarySelected = day
        .where('email', isEqualTo: userEmail)
        .where('dateString', isEqualTo: dateSelected)
        .snapshots();
    return diarySelected;
  }

  Stream<bool> isDiaryEntryExists() {
    DateTime now = DateTime.now();
    String dateToday = '${now.year}-${now.month}-${now.day}';
    final userEmail = auth.currentUser?.email;

    return day
        .where('dateString', isEqualTo: dateToday)
        .where('email', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  Stream<bool> isDiaryEntryExistsDay(String date) {
    final userEmail = auth.currentUser?.email;
    return day
        .where('dateString', isEqualTo: date)
        .where('email', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

//////////////////////////////////////////////////////////////////////
  final CollectionReference dailyTips =
      FirebaseFirestore.instance.collection('daily_tips');

  Future<void> addDailyTips(DailyTips tipsData) async {
    await dailyTips.add(tipsData.toMap());
  }

  Stream<QuerySnapshot> getSelectedDailyTips(Timestamp dateSelected) {
    final userEmail = auth.currentUser?.email;
    final tipsSelected = dailyTips
        .where('email', isEqualTo: userEmail)
        .where('date', isEqualTo: dateSelected)
        .snapshots();
    return tipsSelected;
  }

  Future<void> deleteTips(Timestamp date) async {
    final userEmail = auth.currentUser?.email;
    QuerySnapshot snapshot = await dailyTips
        .where('date', isEqualTo: date)
        .where('email', isEqualTo: userEmail)
        .get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await dailyTips.doc(doc.id).delete();
    }
  }

  Future<void> deleteAllTips(String email) async {
    QuerySnapshot snapshot =
        await dailyTips.where('email', isEqualTo: email).get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await dailyTips.doc(doc.id).delete();
    }
  }

  Future<void> updateTips(Timestamp date, List newTips) async {
    final userEmail = auth.currentUser?.email;
    QuerySnapshot snapshot = await dailyTips
        .where('date', isEqualTo: date)
        .where('email', isEqualTo: userEmail)
        .get();

    Map<String, dynamic> updatedFields = {
      'tips': newTips,
    };

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await dailyTips.doc(doc.id).update(updatedFields);
    }
  }

  //////////////////////////////////////////////////////////////
  final CollectionReference _todo =
      FirebaseFirestore.instance.collection('todo');

  Future<void> addToDo(ToDo toDo) async {
    await _todo.add(toDo.toMap());
  }

  Stream<QuerySnapshot> getToDos(String dateSelected) {
    final userEmail = auth.currentUser?.email;
    final tipsSelected = _todo
        .where('email', isEqualTo: userEmail)
        .where('dateString', isEqualTo: dateSelected)
        .snapshots();
    return tipsSelected;
  }

  Future<void> updateToDo(String date, String toDo, bool done) async {
    final userEmail = auth.currentUser?.email;
    QuerySnapshot snapshot = await _todo
        .where('dateString', isEqualTo: date)
        .where('email', isEqualTo: userEmail)
        .where('task', isEqualTo: toDo)
        .get();

    Map<String, dynamic> updatedFields = {
      'done': done,
    };

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await _todo.doc(doc.id).update(updatedFields);
    }
  }

  Future<void> updateToDoTask(String date, String toDo, String newToDo) async {
    final userEmail = auth.currentUser?.email;
    QuerySnapshot snapshot = await _todo
        .where('dateString', isEqualTo: date)
        .where('email', isEqualTo: userEmail)
        .where('task', isEqualTo: toDo)
        .get();

    Map<String, dynamic> updatedFields = {
      'task': newToDo,
    };

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await _todo.doc(doc.id).update(updatedFields);
    }
  }

  Future<void> deleteSelectedTask(String date, String task) async {
    QuerySnapshot snapshot = await _todo
        .where('dateString', isEqualTo: date)
        .where('task', isEqualTo: task)
        .get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await _todo.doc(doc.id).delete();
    }
  }

  Future<void> deleteAllToDo(String email) async {
    QuerySnapshot snapshot = await _todo.where('email', isEqualTo: email).get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await _todo.doc(doc.id).delete();
    }
  }
}
