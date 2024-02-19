import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_plus/constant.dart';
import 'package:diary_plus/models/emoji.dart';
import 'package:diary_plus/pages/diary_page.dart';
import 'package:diary_plus/pages/read_diary.dart';
import 'package:diary_plus/pages/to_do_list_with_appbar.dart';
import 'package:diary_plus/service/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDate = DateTime.now();
  late CalendarController _calendarController;
  List<String> moodValues = [];
  final userEmail = FirebaseAuth.instance.currentUser?.email;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String formattedDate =
        '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
    FirestoreService fireStoreService = FirestoreService();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Diary',
                  style: TextStyle(
                    color: purple,
                    decorationColor: black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(
                thickness: 2,
                color: purple,
              ),
              TableCalendar(
                focusedDay: _selectedDate,
                firstDay: DateTime(2010, 1, 1),
                lastDay: DateTime(2050, 12, 31),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue, // Set the selected date color
                    shape: BoxShape.circle,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  todayDecoration: BoxDecoration(
                    color: purple,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: purple),
                  formatButtonTextStyle: TextStyle(color: purple),
                  leftChevronIcon: Icon(Icons.chevron_left, color: purple),
                  rightChevronIcon: Icon(Icons.chevron_right, color: purple),
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
                color: purple,
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Selected Date: ${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                  style: TextStyle(fontSize: 18, color: purple),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<bool>(
                //check wheather the diary exists
                stream: fireStoreService.isDiaryEntryExistsDay(
                    '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
                builder: (context, snapshot) {
                  // if selected date is not a future date
                  if (_selectedDate.isBefore(DateTime.now())) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    bool diaryEntryExists = snapshot.data ?? false;

                    return diaryEntryExists
                        //take the diary existing
                        ? StreamBuilder<QuerySnapshot>(
                            stream: fireStoreService.getSelectedDiaryCalendar(
                                '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                  child: Text('No diary entries found.'),
                                );
                              } else {
                                List diaries = snapshot.data!.docs;
                                return Expanded(
                                  child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 12),
                                      itemCount: diaries.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot document =
                                            diaries[index];
                                        String docID = document.id;

                                        Map<String, dynamic> data = document
                                            .data() as Map<String, dynamic>;

                                        String mood = data['mood'];
                                        Timestamp dateTimeStamp = data['date'];

                                        return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'Your mood ',
                                                  ),
                                                  Text(
                                                    emojiMap[mood]!,
                                                    style: const TextStyle(
                                                        fontSize: 30),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: btnPurple,
                                                    foregroundColor:
                                                        Colors.black),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ReadDiary(
                                                                dateSelected:
                                                                    dateTimeStamp,
                                                              )));
                                                },
                                                child:
                                                    const Text('Read My Diary'),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: purple,
                                                    foregroundColor:
                                                        Colors.black),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ToDoListAppBar(
                                                                dateSelected:
                                                                    '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                                                              )));
                                                },
                                                child: const Text(
                                                    'Manage To Do List'),
                                              ),
                                            ]);
                                      }),
                                );
                              }
                            },
                          )
                        //If the diary doesn't exist
                        : Expanded(
                            child: Column(
                              children: [
                                const Text('No diary available.'),
                                const SizedBox(
                                  height: 5,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: btnPurple,
                                      foregroundColor: Colors.black),
                                  onPressed: () {
                                    Timestamp selectedDate =
                                        Timestamp.fromDate(_selectedDate);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (
                                          context,
                                        ) =>
                                                DiaryPage(
                                                  dt: selectedDate,
                                                )));

                                    // Action when the FAB is pressed
                                  },
                                  child: const Text('Add Diary'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: purple,
                                      foregroundColor: Colors.black),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ToDoListAppBar(
                                                  dateSelected:
                                                      '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                                                )));

                                    // Action when the FAB is pressed
                                  },
                                  child: const Text('Manage To Do List'),
                                ),
                              ],
                            ),
                          );
                    // if selected date is a future date
                  } else {
                    return Expanded(
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: purple,
                                foregroundColor: Colors.black),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ToDoListAppBar(
                                            dateSelected:
                                                '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                                          )));

                              // Action when the FAB is pressed
                            },
                            child: const Text('Manage To Do List'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
