import 'package:classbridge/viewmodels/data_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestsDetailScreen extends StatefulWidget {
  const TestsDetailScreen({
    super.key,
    required this.subjectName,
    required this.testName,
    required this.parents,
  });
  final String subjectName;
  final String testName;
  final bool parents;

  @override
  State<TestsDetailScreen> createState() => _TestsDetailScreenState();
}

class _TestsDetailScreenState extends State<TestsDetailScreen> {
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
                '${widget.testName} - ${widget.subjectName}',
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
                    TextEditingController idController =
                        TextEditingController();
                    TextEditingController marksController =
                        TextEditingController();

                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      title: const Text('Add Students Marks'),
                      titleTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                      content: IntrinsicHeight(
                        child: Column(
                          children: [
                            TextField(
                              controller: idController,
                              decoration: const InputDecoration(
                                  hintText: 'Enter Student ID'),
                            ),
                            TextField(
                              controller: marksController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: 'Enter Marks'),
                            ),
                          ],
                        ),
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
                            String idText = idController.value.text.toString();
                            String marksText = marksController.text.toString();
                            String studentName = "";
                            print("checking for idText");
                            print(idText);

                            // Query the 'students' collection to find the student
                            QuerySnapshot studentQuerySnapshot =
                                await FirebaseFirestore.instance
                                    .collection('students')
                                    .where("id", isEqualTo: idText)
                                    .get();

                            if (!studentQuerySnapshot.docs.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Student not found!'),
                                ),
                              );
                              return;
                            } else {
                              // get student name from the document
                              studentName = studentQuerySnapshot.docs.first
                                  .get('name')
                                  .toString();
                            }

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
                                  .doc(widget.testName)
                                  .update({
                                studentName: marksText,
                              }).then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Test  added successfully!'),
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

            int elementIndex = data.tests
                .indexWhere((element) => element.name == widget.testName);
            Map<String, dynamic> testData = data.tests[elementIndex].data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Total Marks",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  testData['total'].toString(),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Students",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  (testData.length - 1).toString(),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                    itemCount: data.tests[elementIndex].data.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // Get the student name from the keys of the testData map
                      String studentName = testData.keys.elementAt(index);
                      if (studentName == "total") {
                        return const SizedBox.shrink(); // Skip the total entry
                      }

                      return ListTile(
                          onTap: () {},
                          leading: Icon(Icons.quiz_rounded),
                          title: Text(testData.keys.elementAt(index),
                              style: const TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                          // subtitle: Text(
                          //     "Tests : ${data.subjects[index].numberOfTests}"),
                          trailing: Text(
                              "${testData.values.elementAt(index)}/100",
                              style: const TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16))); // Add trailing widget here;
                    }),
              ],
            );
          }),
        ),
      ),
    );
  }
}
