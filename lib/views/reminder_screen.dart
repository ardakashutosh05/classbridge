import 'package:classbridge/constants/helper_class.dart';
import 'package:classbridge/viewmodels/data_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: const Row(children: [
            Icon(Icons.campaign_rounded, size: 28),
            SizedBox(width: 10),
            Text('Reminders', style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.w600, fontSize: 20),),
          ],)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Dialog that will allow user to add a reminder that will take text and upload it to firebase.. 
            showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController reminderController = TextEditingController();
              return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: const Text('Announcement'),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
              content: TextField(
                controller: reminderController,
                decoration: const InputDecoration(hintText: 'Enter your message'),
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

                    FirebaseFirestore.instance.collection('reminders').add({
                      'text': reminderText,
                      'timestamp': DateTime.now().millisecondsSinceEpoch,
                    }).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reminder added successfully')),
                      );
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add reminder: $error')),
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
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<FetchData>(context, listen: false).getFunction();
        },
        child: SingleChildScrollView(
          child: Column(
           children: [
             Consumer<FetchData>(
               builder: (context, data, child) {
                if (data.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                 return ListView.builder(
                  itemCount: data.reminders.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.forum_rounded),
                    title: Text(data.reminders[index].text),
                    subtitle: Text(HelperClass.formatTimestampToAmPm(data.reminders[index].timeStamp)),
                    trailing: Icon(Icons.delete_rounded)
                  );
                           });
               }
             ),
           ],
          ),
        ),
      )
    );
  }
}