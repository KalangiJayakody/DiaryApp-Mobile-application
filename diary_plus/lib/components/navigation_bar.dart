import 'package:diary_plus/components/app_bar_menu.dart';
import 'package:diary_plus/constant.dart';
import 'package:diary_plus/pages/calendar.dart';
import 'package:diary_plus/pages/my_diary.dart';
import 'package:diary_plus/pages/to_do_list.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  DateTime today = DateTime.now();
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const MyDiary(),
    ToDoList(
        dateSelected:
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}'),
    const Calendar(),
  ];

  // This is the navigation bar and app bar in each main pages
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3), // Changes position of shadow
              ),
            ],
          ),
          //App bar
          child: AppBar(
            shadowColor: Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Text(
              'Diary +',
              style: TextStyle(
                  color: purple, fontWeight: FontWeight.bold, fontSize: 40),
            ),
            actions: const [AppBarPopupMenu()],
            automaticallyImplyLeading: false,
            elevation: 2,
          ),
        ),
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3), // Changes position of shadow
            ),
          ],
        ),
        //Navigation bar
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: purple, // Set the selected item color
          unselectedItemColor: black, // Set the unselected item color
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'My Diary',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'To Do List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Calender',
            ),
          ],

          elevation: 10,
        ),
      ),
    );
  }
}
