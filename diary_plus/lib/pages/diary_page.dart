import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_plus/api_service/chat_service.dart';
import 'package:diary_plus/constant.dart';
import 'package:diary_plus/models/daily_tips.dart';
import 'package:diary_plus/models/diary.dart';
import 'package:diary_plus/models/emoji.dart';
import 'package:diary_plus/pages/diary_page_with_tips.dart';
import 'package:diary_plus/service/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key, required this.dt});
  final Timestamp dt;

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late DateTime date;
  late Timestamp dateWrite;
  final FirestoreService fireStoreService = FirestoreService();
  String emoji = 'default';
  final FocusNode _focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateWrite = widget.dt;
    date = dateWrite.toDate(); // Accessing the variable within the State class
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = '${date.year}-${date.month}-${date.day}';
    String currentDay = DateFormat('EEEE').format(date);
    String diaryEntry = ''; // Variable to store the diary entry

    @override
    void dispose() {
      textEditingController.dispose();
      super.dispose();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Diary',
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
                // Get the tips
                String question2 =
                    " Give some 5 tips in a paragraph to make the day better. Please include 5 short sentences in this paragraph. Never provide first descriptive sentence. Never break the paragraph in to new lines.";
                String? request2 = textEditingController.text + question2;
                String? response2 = await ChatService().request(request2) ?? '';
                final tipsWrote = response2.split('.');
                final FirebaseAuth auth = FirebaseAuth.instance;
                final userEmail = auth.currentUser?.email;
                DateTime dt = dateWrite.toDate();
                String convertedDate = '${dt.year}-${dt.month}-${dt.day}';
                Diary diary = Diary(
                    email: userEmail,
                    date: dateWrite,
                    description: textEditingController.text,
                    mood: response1,
                    dateString: convertedDate);
                DailyTips tipsAdd = DailyTips(
                    date: dateWrite, email: userEmail, tips: tipsWrote);
                // If tips or/and mood null
                if (response1 == 'failed' || response2 == 'failed') {
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
                    await fireStoreService.addDay(diary);
                    await fireStoreService.addDailyTips(tipsAdd);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiaryPagewithTips(
                            todayDate: Timestamp.fromDate(date)),
                      ),
                    );
                  } catch (e) {
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
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                              emojiMap[emoji]!,
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
                          hintText: 'Write your diary entry here',
                        ),
                      ),
                    ]),
              )),
        ));
  }
}
