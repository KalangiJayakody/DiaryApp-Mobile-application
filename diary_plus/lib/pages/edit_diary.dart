import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_plus/api_service/chat_service.dart';
import 'package:diary_plus/constant.dart';
import 'package:diary_plus/models/emoji.dart';
import 'package:diary_plus/pages/diary_page_with_tips.dart';
import 'package:diary_plus/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditDiaryScreen extends StatefulWidget {
  const EditDiaryScreen({super.key, required this.dateEditPage});
  final Timestamp dateEditPage;

  @override
  State<EditDiaryScreen> createState() => _EditDiaryScreenState();
}

class _EditDiaryScreenState extends State<EditDiaryScreen> {
  late Timestamp dateEdit;
  late DateTime date;
  late String formattedDate;
  late String currentDay;
  final FocusNode _focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateEdit = widget.dateEditPage;
    date = dateEdit.toDate();
    formattedDate = '${date.year}-${date.month}-${date.day}';
    currentDay = DateFormat('EEEE').format(date);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  String diaryEntry = ''; // Variable to store the diary entry

  @override
  Widget build(BuildContext context) {
    FirestoreService fireStoreService = FirestoreService();
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit My Diary',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: purple,
          actions: [
            IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                // Get the correct mood
                String question1 =
                    " This is a diary content someone wrote. Which is the correct mood explain the feeling of the writer. Choose one of these:happy, disappointed, frustrated, embarrassed, annoyed, shocked, cool, funny, goofy, quiet, nervous, angry, bored, tired, sad, scared, sick, fuming, busy.  Output one word from the given list.";
                String request1 = textEditingController.text + question1;
                String response1 = await ChatService().request(request1) ?? '';
                // Get the correct tips
                String question2 =
                    " Give some 5 tips in a paragraph to make the day better. Please include 5 short sentences in this paragraph. Never provide first descriptive sentence. Never break the paragraph in to new lines.";
                String? request2 = textEditingController.text + question2;
                String? response2 = await ChatService().request(request2) ?? '';
                List<String> tips = response2.split('.');
                //If mood or/and tips are null
                if (response1 == 'failed' || response2 == 'failed') {
                  if (_focusNode.hasFocus) {
                    _focusNode.unfocus();
                  }
                  Navigator.pop(context);
                  final snackBar = SnackBar(
                    content: Text(
                      'Failed: Low internet conncetion. Try again',
                      style: TextStyle(color: black),
                    ),
                    backgroundColor: btnPurple,
                    duration: const Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  //Otherwise
                } else {
                  try {
                    if (_focusNode.hasFocus) {
                      _focusNode.unfocus();
                    }
                    await fireStoreService.updateDay(
                        dateEdit, response1, textEditingController.text);
                    await fireStoreService.updateTips(dateEdit, tips);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiaryPagewithTips(
                            todayDate: Timestamp.fromDate(date)),
                      ),
                    );
                    //Exception
                  } catch (e) {
                    if (_focusNode.hasFocus) {
                      _focusNode.unfocus();
                    }
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                      content: Text(
                        'Failed: Please try again',
                        style: TextStyle(color: black),
                      ),
                      backgroundColor: btnPurple,
                      duration: const Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
              icon: const Icon(Icons.done),
              iconSize: 30,
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            //Takes the existing diary record
            child: StreamBuilder<QuerySnapshot>(
              stream: fireStoreService.getSelectedDiary(dateEdit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
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
                        textEditingController.text = data['description'];
                        String mood = data['mood'];
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
                              TextField(
                                controller: textEditingController,
                                maxLines: null, // Allows multiline input
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: black,
                                    fontSize: 18),
                                decoration: const InputDecoration(
                                  border: InputBorder.none, // Remove border
                                  focusedBorder:
                                      InputBorder.none, // Remove focused border
                                ),
                              ),
                            ]);
                      });
                }
              },
            ),
          ),
        ));
  }
}
