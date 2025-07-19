import 'package:classbridge/viewmodels/data_viewmodel.dart';
import 'package:classbridge/views/tests_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestsScreen extends StatefulWidget {
  bool parents;
  TestsScreen({super.key, required this.subjectName, required this.parents});
  final String subjectName;

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Icon(Icons.checklist_rounded, size: 28),
              SizedBox(width: 10),
              Text(
                'Tests - ${widget.subjectName}',
                style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ],
          )),
      floatingActionButton: widget.parents
          ? SizedBox.shrink()
          : FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController testController =
                        TextEditingController();
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      title: const Text('Add Test'),
                      titleTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                      content: TextField(
                        controller: testController,
                        decoration:
                            const InputDecoration(hintText: 'Enter test name'),
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
                          onPressed: () async {
                            String testText = testController.text;
                            // Query the 'subjects' collection to find the document
                            QuerySnapshot subjectQuery = await FirebaseFirestore
                                .instance
                                .collection('subjects')
                                .where('subjectName',
                                    isEqualTo: widget.subjectName)
                                .get();

                            if (subjectQuery.docs.isNotEmpty) {
                              // Get the document ID of the found document
                              String subjectDocId = subjectQuery.docs.first.id;

                              // Add the test to the found subject document
                              FirebaseFirestore.instance
                                  .collection('subjects')
                                  .doc(subjectDocId)
                                  .collection("tests")
                                  .doc(testText)
                                  .set({
                                "total": 100,
                              }).then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Test $testText added successfully!'),
                                  ),
                                );
                                Provider.of<FetchData>(context, listen: false)
                                    .getTestDataForSubject(widget.subjectName);
                                Navigator.of(context).pop();
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to add test: $error'),
                                  ),
                                );
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Subject not found!'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Consumer<FetchData>(builder: (context, data, child) {
            if (data.isTestDataLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                    itemCount: data.tests.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () {
                            // Navigate to the test detail screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TestsDetailScreen(
                                  subjectName: widget.subjectName,
                                  testName: data.tests[index].name,
                                  parents: widget.parents,
                                ),
                              ),
                            );
                          },
                          leading: Icon(Icons.quiz_rounded),
                          title: Text(data.tests[index].name,
                              style: const TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                          // subtitle: Text(
                          //     "Tests : ${data.subjects[index].numberOfTests}"),
                          trailing: Icon(Icons.delete_rounded));
                    }),
              ],
            );
          }),
        ),
      ),
    );
  }
}
