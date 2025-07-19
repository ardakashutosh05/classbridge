import 'package:classbridge/viewmodels/data_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
            Icon(Icons.group_rounded, size: 28),
            SizedBox(width: 10),
            Text('Students', style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.w600, fontSize: 20),),
          ],)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController nameController = TextEditingController();
          TextEditingController idController = TextEditingController();
          String selectedClass = 'I';
          return StatefulBuilder(
            builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: const Text('Add Student'),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Name of the student'),
            ),
            TextField(
              controller: idController,
              decoration: const InputDecoration(hintText: 'ID of the student'),
            ),
            DropdownButtonFormField<String>(
              value: selectedClass,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              items: <String>['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X']
              .map((String value) {
                return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
              selectedClass = newValue!;
                });
              },
            ),
              ],
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
              String name = nameController.text;
              String id = idController.text;
              if (name.isNotEmpty && id.isNotEmpty && selectedClass.isNotEmpty) {
                FirebaseFirestore.instance.collection('students').add({
              'name': name,
              'id': id,
              'class': selectedClass,
              'timestamp': DateTime.now().millisecondsSinceEpoch,
                }).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Student added successfully')),
              );
              Navigator.of(context).pop();
                }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to add student: $error')),
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
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
         children: [
           Consumer<FetchData>(
             builder: (context, data, child) {
              if (data.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
               return ListView.builder(
                itemCount: data.students.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.person_rounded),
                  title: Text(data.students[index].name),
                  subtitle: Text("${data.students[index].id} - ${data.students[index].className}"),
                  trailing: Icon(Icons.delete_rounded)
                );
                         });
             }
           ),
         ],
        ),
      )
      
    );
  }
}