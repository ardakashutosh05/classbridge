import 'package:classbridge/constants/color_const.dart';
import 'package:classbridge/constants/helper_class.dart';
import 'package:classbridge/views/chat_list_screen.dart';
import 'package:classbridge/views/chatbot_screen.dart';
import 'package:classbridge/views/home_screen.dart';
import 'package:classbridge/views/parents_screen/parents_home_screen.dart';
import 'package:classbridge/views/profile_screen.dart';
import 'package:classbridge/views/reminder_screen.dart';
import 'package:classbridge/views/students_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ParentsMainScreen extends StatefulWidget {
  const ParentsMainScreen({super.key});
  @override
  State<ParentsMainScreen> createState() => _ParentsMainScreenState();
}

class _ParentsMainScreenState extends State<ParentsMainScreen> {
  GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    ParentsHomeScreen(),
    ChatScreen(chatId: HelperClass.generateRandomString()),
    ChatListScreen(userId: FirebaseAuth.instance.currentUser!.uid, isTeacher: false),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Sizer(
        builder: (p0, p1, p2) {
          return Scaffold(
            key: homeScaffoldKey,
            backgroundColor: primaryBlueCustomColor,
            body: _widgetOptions[_selectedIndex],
            bottomNavigationBar: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cart Summary Row - Only show when cart has items
                  BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.white,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined,
                            color: _selectedIndex == 0
                                ? primaryBlueCustomColor
                                : Colors.black),
                        activeIcon: Icon(Icons.home_rounded,
                            color: primaryBlueCustomColor),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.message_rounded,
                            color: _selectedIndex == 1
                                ? primaryBlueCustomColor
                                : Colors.black),
                        activeIcon: Icon(Icons.message_rounded,
                            color: primaryBlueCustomColor),
                        label: 'Chat',
                      ),BottomNavigationBarItem(
                        icon: Icon(Icons.forum_rounded,
                            color: _selectedIndex == 2
                                ? primaryBlueCustomColor
                                : Colors.black),
                        activeIcon: Icon(Icons.forum_rounded,
                            color: primaryBlueCustomColor),
                        label: 'Feedbacks',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline,
                            color: _selectedIndex == 3
                                ? primaryBlueCustomColor
                                : Colors.black),
                        activeIcon: Icon(Icons.person_rounded,
                            color: primaryBlueCustomColor),
                        label: 'Profile',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: primaryBlueCustomColor,
                    unselectedItemColor: Colors.grey,
                    onTap: _onItemTapped,
                    showUnselectedLabels: true,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
