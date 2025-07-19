import 'package:classbridge/viewmodels/data_viewmodel.dart';
import 'package:classbridge/views/tests_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController reminderController =
                  TextEditingController();
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                title: const Text('Add Subject'),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
                content: TextField(
                  controller: reminderController,
                  decoration:
                      const InputDecoration(hintText: 'Enter subject name'),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Send'),
                    onPressed: () {
                      // Code to upload the reminder to Firebase
                      String reminderText = reminderController.text;
                      if (reminderText.isNotEmpty) {
                        // Code to upload the reminder to Firebase

                        FirebaseFirestore.instance.collection('subjects').add({
                          'subjectName': reminderText,
                          'numberOfTests': 0,
                        }).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Subject added successfully')),
                          );
                          Navigator.of(context).pop();
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to add Subject: $error')),
                          );
                        });
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Row(
            children: [
              Icon(Icons.grid_view_rounded, size: 28),
              SizedBox(width: 10),
              Text(
                'Subjects',
                style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ],
          )),
      body: Consumer<FetchData>(builder: (context, data, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 20),
                // const Text(
                //   'All Subjects',
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                data.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: data.subjects.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                              onTap: () {
                                Provider.of<FetchData>(context, listen: false)
                                    .getTestDataForSubject(
                                        data.subjects[index].subjectName);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TestsScreen(
                                            subjectName: data
                                                .subjects[index].subjectName,
                                            parents: false)));
                              },
                              leading: Icon(Icons.book_rounded),
                              title: Text(data.subjects[index].subjectName,
                                  style: const TextStyle(
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                              subtitle: Text(
                                  "Tests : ${data.subjects[index].numberOfTests}"),
                              trailing: Icon(Icons.delete_rounded));
                        })
              ],
            ),
          ),
        );
      }),
    );
  }
}
