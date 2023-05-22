import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherListPage extends StatefulWidget {
  @override
  _TeacherListPageState createState() => _TeacherListPageState();
}

class _TeacherListPageState extends State<TeacherListPage> {
  late Stream<QuerySnapshot> _teachersStream;

  @override
  void initState() {
    super.initState();
    _teachersStream = FirebaseFirestore.instance.collection('teachers').snapshots();
  }

  void _deleteTeacher(String? teacherId) {
    if (teacherId != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete this teacher?'),
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
                  FirebaseFirestore.instance.collection('teachers').doc(teacherId).delete();
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
        title: Text('Teacher List'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go to previous page
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _teachersStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No teachers found'));
          }

          final docs = snapshot.data?.docs;

          return ListView.builder(
            itemCount: docs?.length,
            itemBuilder: (context, index) {
              final teacherData = docs?[index].data() as Map<String, dynamic>?;
              final teacherId = docs?[index].id;

              if (teacherData == null) {
                return SizedBox(); // Return an empty SizedBox if the teacherData is null
              }

              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(teacherData['name'] ?? ''),
                  subtitle: Text(teacherData['number'] ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTeacher(teacherId),
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
