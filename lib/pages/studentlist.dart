import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  late Stream<QuerySnapshot> _studentsStream;

  @override
  void initState() {
    super.initState();
    _studentsStream = FirebaseFirestore.instance.collection('students').snapshots();
  }

  void _deleteStudent(String? studentId) {
    if (studentId != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete this student?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  FirebaseFirestore.instance.collection('students').doc(studentId).delete();
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go to previous page
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _studentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No students found'));
          }

          final docs = snapshot.data?.docs;

          return ListView.builder(
            itemCount: docs?.length,
            itemBuilder: (context, index) {
              final studentData = docs?[index].data() as Map<String, dynamic>?;
              final studentId = docs?[index].id;

              if (studentData == null) {
                return SizedBox(); // Return an empty SizedBox if the studentData is null
              }

              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(studentData['name']?.substring(0, 1) ?? ''),
                  ),
                  title: Text(studentData['name'] ?? ''),
                  subtitle: Text(studentData['usn'] ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteStudent(studentId),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
