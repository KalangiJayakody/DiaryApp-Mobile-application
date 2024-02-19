import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_plus/constant.dart';
import 'package:diary_plus/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiaryPagewithTips extends StatefulWidget {
  DiaryPagewithTips({super.key, required this.todayDate});
  Timestamp todayDate;

  @override
  State<DiaryPagewithTips> createState() => _DiaryPagewithTipsState();
}

class _DiaryPagewithTipsState extends State<DiaryPagewithTips> {
  late DateTime displayDate;
  late Timestamp selectedDate;
  late String formattedDate;
  late String currentDay;
  late String formattedTime;

  @override
  void initState() {
    super.initState();
    displayDate = widget.todayDate.toDate();
    selectedDate = widget.todayDate;
    formattedDate =
        '${displayDate.year}-${displayDate.month}-${displayDate.day}';
    currentDay = DateFormat('EEEE').format(displayDate);
    formattedTime = DateFormat.jm().format(displayDate);
  }

// This page displays the tips of the particular diary
  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = FirestoreService();
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Hey Follow this tips',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: purple,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                //This takes the tips for the particular day
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getSelectedDailyTips(selectedDate),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Your device has no strong connection',
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
                          'No tips found.',
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
                            List tips = data['tips'];
                            Timestamp dateTimeStamp = data['date'];
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
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
                                              ' , ',
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
                                          ],
                                        ),
                                        Text(
                                          formattedTime,
                                          style: TextStyle(
                                            color: purple,
                                            decorationColor: black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 2,
                                  color: purple,
                                ),
                                Card(
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
                                          const Text(
                                            'Tip 01 :',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            tips[0] ?? '',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Card(
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
                                          const Text(
                                            'Tip 02 :',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            tips[1] ?? '',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Card(
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
                                          const Text(
                                            'Tip 03 :',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            tips[2] ?? '',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Card(
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
                                          const Text(
                                            'Tip 04 :',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            tips[3] ?? '',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Card(
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
                                          const Text(
                                            'Tip 05 :',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            tips[4] ?? '',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    }
                  },
                ),
              ),
            ],
          ),
        )));
  }
}
