import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_plus/constant.dart';
import 'package:diary_plus/models/to_do.dart';
import 'package:diary_plus/service/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ToDoListAppBar extends StatefulWidget {
  const ToDoListAppBar({super.key, required this.dateSelected});
  final String dateSelected;

  @override
  State<ToDoListAppBar> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoListAppBar> {
  final FocusNode _focusNode = FocusNode();
  FirestoreService firestoreService = FirestoreService();
  Timestamp toDay = Timestamp.fromDate(DateTime.now());
  DateTime today = DateTime.now();
  late String dateGot;

  @override
  void initState() {
    super.initState();
    dateGot = widget.dateSelected;
  }

// update to do task
  void updateToDoTask(String existingTask) async {
    TextEditingController textEditingController = TextEditingController();
    textEditingController.text = existingTask;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Update Task',
            style: TextStyle(color: purple),
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: existingTask,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final FirebaseAuth auth = FirebaseAuth.instance;
                // You can use the 'userInput' variable to get the entered text
                if (textEditingController.text != '') {
                  try {
                    final email =
                        FirebaseAuth.instance.currentUser?.email ?? 'No Email';

                    await firestoreService.updateToDoTask(
                        dateGot, existingTask, textEditingController.text);
                    Navigator.pop(context);

                    // Show success message or navigate to login screen
                  } on FirebaseException {
                    // Show error message
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
                  } on SocketException {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                      content: Text(
                        'Failed: Poor connection Try again!',
                        style: TextStyle(color: black),
                      ),
                      backgroundColor: btnPurple,
                      duration: const Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                } else {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (contaxt) {
                      return AlertDialog(
                        title: Text(
                          'Error',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: purple,
                          ),
                        ),
                        content: const Text("Task is empty!!!"),
                      );
                    },
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

// add to do task
  void addTodayToDo() async {
    String userInput = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add New Task',
            style: TextStyle(color: purple),
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    userInput = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Type task',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final FirebaseAuth auth = FirebaseAuth.instance;
                // You can use the 'userInput' variable to get the entered text
                if (userInput != '') {
                  try {
                    final email =
                        FirebaseAuth.instance.currentUser?.email ?? 'No Email';
                    ToDo newToDo = ToDo(
                        date: toDay,
                        email: email,
                        dateString: dateGot,
                        task: userInput,
                        done: false);
                    await firestoreService.addToDo(newToDo);
                    Navigator.pop(context);

                    // Show success message or navigate to login screen
                  } on FirebaseException {
                    // Show error message
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
                  } on SocketException {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                      content: Text(
                        'Failed: Poor connection Try again!',
                        style: TextStyle(color: black),
                      ),
                      backgroundColor: btnPurple,
                      duration: const Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                } else {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (contaxt) {
                      return AlertDialog(
                        title: Text(
                          'Error',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: purple,
                          ),
                        ),
                        content: const Text("Task is empty!!!"),
                      );
                    },
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

// delete to do task
  void deleteToDo(String task) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Task',
            style: TextStyle(color: purple),
          ),
          content: Container(
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Are you sure about deleting this task?')],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final FirebaseAuth auth = FirebaseAuth.instance;
                // You can use the 'userInput' variable to get the entered text

                try {
                  final email =
                      FirebaseAuth.instance.currentUser?.email ?? 'No Email';

                  await firestoreService.deleteSelectedTask(dateGot, task);
                  Navigator.pop(context);

                  // Show success message or navigate to login screen
                } on FirebaseException {
                  // Show error message
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
                } on SocketException {
                  Navigator.pop(context);
                  final snackBar = SnackBar(
                    content: Text(
                      'Failed: Poor connection Try again!',
                      style: TextStyle(color: black),
                    ),
                    backgroundColor: btnPurple,
                    duration: const Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  // Building frontend
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To Do List',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: purple,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'To Do List - ',
                  style: TextStyle(
                    color: purple,
                    decorationColor: black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  dateGot,
                  style: TextStyle(
                    color: purple,
                    decorationColor: black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 2,
              color: purple,
            ),
            Expanded(
              //Get existing tasks
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getToDos(dateGot),
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
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No tasks are found.',
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

                          Timestamp dateTimeStamp = data['date'];
                          DateTime date = dateTimeStamp.toDate();
                          bool done = data['done'];
                          String task = data['task'];

                          return Card(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            elevation: 1, // Shadow depth
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Rounded corners
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Checkbox(
                                                  value: done,
                                                  activeColor: purple,
                                                  onChanged: (value) async {
                                                    setState(() {
                                                      done = !done;
                                                    });
                                                    firestoreService.updateToDo(
                                                        dateGot, task, (done));
                                                  }),
                                              Text(
                                                task,
                                                style: const TextStyle(
                                                    fontSize: 18),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    updateToDoTask(task);
                                                  },
                                                  color: purple,
                                                  icon: const Icon(Icons.edit)),
                                              IconButton(
                                                  onPressed: () {
                                                    deleteToDo(task);
                                                  },
                                                  color: purple,
                                                  icon:
                                                      const Icon(Icons.delete)),
                                            ],
                                          )
                                        ]),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ),
      )),
      // Adding tasks button
      floatingActionButton: FractionallySizedBox(
        widthFactor: 0.14,
        child: FloatingActionButton(
          backgroundColor: btnPurple,
          onPressed: () {
            addTodayToDo();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
