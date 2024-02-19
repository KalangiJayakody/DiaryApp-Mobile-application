import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_plus/constant.dart';
import 'package:diary_plus/models/emoji.dart';
import 'package:diary_plus/pages/diary_page_with_tips.dart';
import 'package:diary_plus/pages/edit_diary.dart';
import 'package:diary_plus/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReadDiary extends StatefulWidget {
  const ReadDiary({super.key, required this.dateSelected});
  final Timestamp dateSelected;

  @override
  State<ReadDiary> createState() => _ReadDiaryState();
}

class _ReadDiaryState extends State<ReadDiary> {
  final FirestoreService fireStoreService = FirestoreService();
  late Timestamp selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.dateSelected;
  }

  @override

  // Building frontend
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Read My Diary',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: purple,
          actions: [
            //Edit button
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (
                      context,
                    ) =>
                            EditDiaryScreen(
                              dateEditPage: selectedDate,
                            )));
              },
              icon: const Icon(Icons.edit),
              iconSize: 30,
            ),
            //Delete button
            IconButton(
              onPressed: () {
                fireStoreService.deleteDay(selectedDate);
                fireStoreService.deleteTips(selectedDate);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
              iconSize: 30,
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: fireStoreService.getSelectedDiary(selectedDate),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error fetching diary'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No diary entries found.'),
                  );
                } else {
                  List diaries = snapshot.data!.docs;
                  return ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: diaries.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = diaries[index];
                        String docID = document.id;

                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        String descritption = data['description'];
                        String mood = data['mood'];
                        Timestamp dateTimeStamp = data['date'];

                        ///*List tips = data['tips'];
                        DateTime date = dateTimeStamp.toDate();
                        String formattedDate =
                            '${date.year}-${date.month}-${date.day}';
                        String currentDay = DateFormat('EEEE').format(date);
                        final formattedTime = DateFormat.jm().format(date);

                        return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            formattedDate,
                                            style: TextStyle(
                                              color: purple,
                                              decorationColor: black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            currentDay,
                                            style: TextStyle(
                                              color: purple,
                                              decorationColor: black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                    Text(
                                      emojiMap[mood] ?? emojiMap['default']!,
                                      style: const TextStyle(fontSize: 30),
                                    ),
                                  ]),
                              Divider(
                                thickness: 2,
                                color: purple,
                              ),
                              Text(
                                descritption,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: black,
                                    fontSize: 18),
                              ),
                            ]);
                      });
                }
              },
            ),
          ),
        ),
        // Display tips button
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: screenWidth * 0.8,
              child: FloatingActionButton(
                  backgroundColor: btnPurple,
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (
                          context,
                        ) =>
                                DiaryPagewithTips(
                                  todayDate: selectedDate,
                                )));

                    // Action when the FAB is pressed
                  },
                  child: const Text('Find Your Tips Here')),
            ),
          ],
        ));
  }
}
