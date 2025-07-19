import 'package:classbridge/components/performance_carousel.dart';
import 'package:classbridge/constants/helper_class.dart';
import 'package:classbridge/viewmodels/data_viewmodel.dart';
import 'package:classbridge/views/subjects_screen.dart';
import 'package:classbridge/views/tests_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParentsHomeScreen extends StatefulWidget {
  const ParentsHomeScreen({super.key});

  @override
  State<ParentsHomeScreen> createState() => _ParentsHomeScreenState();
}

class _ParentsHomeScreenState extends State<ParentsHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
            title: const Row(
          children: [
            Icon(Icons.school_rounded, size: 28),
            SizedBox(width: 10),
            Text(
              'Parents Home',
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.studentName,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Class: ${data.studentClass}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        )
                      ]),
                  const SizedBox(height: 30),
                  const Text(
                    'Teachers Announcements',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Consumer<FetchData>(builder: (context, data, child) {
                    if (data.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                        itemCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(Icons.forum_rounded),
                            title: Text(data.reminders[index].text),
                            subtitle: Text(HelperClass.formatTimestampToAmPm(
                                data.reminders[index].timeStamp)),
                          );
                        });
                  }),
                  const SizedBox(height: 20),
                                    _buildPerformanceSection(),


    const SizedBox(height: 20),
                  const Text(
                    'Subjects',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  data.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2.5,
                          ),
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
                                            parents: true)));
                              },
                              leading: Icon(Icons.book_rounded),
                              title: Text(data.subjects[index].subjectName,
                                  style: const TextStyle(
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                              subtitle: Text(
                                  "Tests : ${data.subjects[index].numberOfTests}"),
                            );
                          }),

                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;

  const MetricCard({required this.title, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final VoidCallback ontap;

  ActionCard({required this.title, Key? key, required this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: ontap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildPerformanceSection() {
  return Consumer<FetchData>(
    builder: (context, dataProvider, child) {
      if (dataProvider.isTestDataLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (dataProvider.tests.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No test data available for this student'),
          ),
        );
      }

      final performances = dataProvider.processTestData(dataProvider.tests);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Academic Performance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Student: ${dataProvider.studentName}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Class: ${dataProvider.studentClass}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          PerformanceCarousel(performances: performances),
        ],
      );
    },
  );
}