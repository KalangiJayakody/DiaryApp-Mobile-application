import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_plus/constant.dart';
import 'package:diary_plus/models/emoji.dart';
import 'package:diary_plus/pages/read_diary.dart';
import 'package:diary_plus/pages/diary_page.dart';
import 'package:diary_plus/service/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDiary extends StatefulWidget {
  const MyDiary({super.key});

  @override
  State<MyDiary> createState() => _MyDiaryState();
}

class _MyDiaryState extends State<MyDiary> {
  // Setting a greeting function
  String _getGreeting(int hour) {
    String greeting = '';

    if (hour < 12) {
      greeting = 'Good Morning...';
    } else if (hour < 18) {
      greeting = 'Good Afternoon...';
    } else {
      greeting = 'Good Evening...';
    }

    return greeting;
  }

// Setting an idiom for the time
  String _getGreeting2(int hour) {
    String greeting2 = '';

    if (hour < 12) {
      greeting2 = 'Dawn whispers promises of new beginnings...';
    } else if (hour < 18) {
      greeting2 = 'Sunlit moments bloom with shared ideas...';
    } else {
      greeting2 = 'Dusk paints dreams in the night\'s embrace...';
    }

    return greeting2;
  }

// Setting an image matching to the time
  String _getImage(int hour) {
    String image;

    if (hour < 4) {
      image = "lib/assets/day2.jpg";
    } else if (hour < 6) {
      image = "lib/assets/day3.jpg";
    } else if (hour < 15) {
      image = "lib/assets/day5.jpg";
    } else if (hour < 18) {
      image = "lib/assets/day1.jpg";
    } else if (hour < 20) {
      image = "lib/assets/day6.jpg";
    } else {
      image = "lib/assets/day4.jpg";
    }

    return image;
  }

  @override
  //Building fornt end
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email;
    DateTime now = DateTime.now();
    int hour = now.hour;

    String greeting = _getGreeting(hour);
    String greeting2 = _getGreeting2(hour);
    String imageSelected = _getImage(hour);

    double screenWidth = MediaQuery.of(context).size.width;

    final FirestoreService fireStoreService = FirestoreService();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Block part
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage(imageSelected), // Replace with your image
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  greeting,
                                  style: TextStyle(
                                    color: Colors.white,
                                    decorationColor: black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              greeting2,
                              style: TextStyle(
                                  color: Colors.white,
                                  decorationColor: black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900),
                            ),
                          ]),
                    )
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                //Existing diaries visualizing part
                Text(
                  'My Diary',
                  style: TextStyle(
                    color: purple,
                    decorationColor: black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: purple,
                ),
                Expanded(
                  //This takes the list of diaries available
                  child: StreamBuilder<QuerySnapshot>(
                    stream: fireStoreService.getDiary(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Error fetching your diaries',
                            style: TextStyle(
                              fontSize: 16,
                              //fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No diary entries found.',
                            style: TextStyle(
                              fontSize: 16,
                              //fontWeight: FontWeight.w600),
                            ),
                          ),
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
                              DateTime date = dateTimeStamp.toDate();
                              String formattedDate =
                                  '${date.year}-${date.month}-${date.day}';
                              String currentDay =
                                  DateFormat('EEEE').format(date);
                              final formattedTime =
                                  DateFormat.jm().format(date);

                              final String longText = descritption;
                              //Making the card responsible
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ReadDiary(
                                                dateSelected: dateTimeStamp,
                                              )));
                                },
                                child: Card(
                                  // Customize the card properties as needed
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  elevation: 1, // Shadow depth
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        12.0), // Rounded corners
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SizedBox(
                                      width: screenWidth,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      formattedDate,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: purple),
                                                    ),
                                                    Text(
                                                      '  ,  ',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: purple),
                                                    ),
                                                    Text(
                                                      currentDay,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: purple),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  emojiMap[mood] ??
                                                      emojiMap['default']!,
                                                  style: const TextStyle(
                                                      fontSize: 28),
                                                )
                                              ]),
                                          Text(
                                            formattedTime,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: black),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            descritption,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              //fontWeight: FontWeight.w600),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.justify,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ]),
        ),
      ),
      //Diaplay the floating button when current day diary is not existing
      floatingActionButton: StreamBuilder<bool>(
        stream: fireStoreService.isDiaryEntryExists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          bool diaryEntryExists = snapshot.data ?? false;

          return diaryEntryExists
              ? Container()
              : FloatingActionButton(
                  backgroundColor: btnPurple,
                  onPressed: () {
                    Timestamp currentDate = Timestamp.now();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (
                          context,
                        ) =>
                                DiaryPage(
                                  dt: currentDate,
                                )));

                    // Action when the FAB is pressed
                  },
                  child: const Icon(Icons.add),
                ); // Hide the FAB if today's record exists
        },
      ),
    );
  }
}
