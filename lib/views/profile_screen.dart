import 'package:classbridge/constants/helper_class.dart';
import 'package:classbridge/model/user_model.dart';
import 'package:classbridge/viewmodels/data_viewmodel.dart';
import 'package:classbridge/views/signin_screen.dart';
import 'package:classbridge/views/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Row(
          children: [
            Icon(Icons.person_rounded, size: 28),
            SizedBox(width: 10),
            Text(
              'Profile',
              style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
          ],
        )),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Consumer<FetchData>(builder: (context, data, child) {
                  if (data.isUserDataLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 200),
                      // const Text(
                      //   'Personal Information',
                      //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      // ),
                      // const SizedBox(height: 10),
                      ListTile(
                        leading: Icon(Icons.person_rounded),
                        title: Text(
                            '${data.user!.firstName} ${data.user!.lastName}'),
                      ),
                      ListTile(
                        leading: Icon(Icons.email_rounded),
                        title: Text(data.user!.email),
                      ),
                      // ListTile(
                      //   leading: Icon(Icons.school_rounded),
                      //   title: Text('Teacher'),
                      // ),
                      ListTile(
                        leading: Icon(Icons.login_rounded),
                        title: Text(
                            'Joined on ${HelperClass.formatTimestampToAmPm(data.user!.loginTimestamp)}'),
                      ),
                      ListTile(
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SplashScreen(
                                        bifurcation: true,
                                      )));
                        },
                        leading: Icon(Icons.logout_rounded, color: Colors.red),
                        title: Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                }))));
  }
}
