import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';



class Assignment {
  final String id;
  final String semester;
  final String title;
  final String fileUrl;

  Assignment(this.id, this.semester, this.title, this.fileUrl);

  Assignment.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        semester = snapshot['semester'],
        title = snapshot['title'],
        fileUrl = snapshot['fileUrl'];
}

class AssignmentsPage extends StatefulWidget {
  @override
  _AssignmentsPageState createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  TextEditingController _searchController = TextEditingController();
  String _semesterFilter = '';
  List<Assignment> _assignments = [];
  List<Assignment> _filteredAssignments = [];

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  void _loadAssignments() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('assignments').get();
    List<Assignment> assignments =
    snapshot.docs.map((doc) => Assignment.fromSnapshot(doc)).toList();
    setState(() {
      _assignments = assignments;
      _filteredAssignments = assignments;
    });
  }

  void _uploadAssignment(String semester, String title) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      String? fileUrl = file.path;

      if (fileUrl != null) {
        await FirebaseFirestore.instance.collection('assignments').add({
          'semester': semester,
          'title': title,
          'fileUrl': fileUrl,
        });
        _loadAssignments();
      } else {
        // Handle the case when file path is null
        // You can show an error message or handle it in any other way you prefer
      }
    }
  }

  void _filterAssignments(String filter) {
    setState(() {
      _semesterFilter = filter;
      _filteredAssignments = _assignments
          .where((assignment) =>
      assignment.semester.toLowerCase().contains(filter.toLowerCase()) ||
          assignment.title.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    });
  }


  void _deleteAssignment(Assignment assignment) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Assignment'),
          content: Text('Are you sure you want to delete this assignment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Delete the assignment from Firestore
                await FirebaseFirestore.instance.collection('assignments').doc(assignment.id).delete();
                Navigator.pop(context); // Close the dialog
                _loadAssignments();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // void _downloadAssignment(String fileUrl) async {
  //   final taskId = await FlutterDownloader.enqueue(
  //     url: fileUrl,
  //     savedDir: '/path/to/save/directory', // Replace with the desired save directory path
  //     showNotification: true,
  //     openFileFromNotification: true,
  //   );
  // }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterAssignments,
              decoration: InputDecoration(
                labelText: 'Search by Semester or Title',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _filteredAssignments.length,
              itemBuilder: (context, index) {
                Assignment assignment = _filteredAssignments[index];
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${assignment.semester}: ${assignment.title}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      // IconButton(
                      //   icon: Icon(Icons.download),
                      //   onPressed: () {
                      //     _downloadAssignment(assignment.fileUrl); // Call the download method
                      //   },
                      // ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteAssignment(assignment); // Call the delete method
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String semester = '';
              String title = '';

              return AlertDialog(
                title: Text('Upload Assignment'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Semester'),
                      onChanged: (value) => semester = value,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      onChanged: (value) => title = value,
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      _uploadAssignment(semester, title);
                      Navigator.pop(context);
                    },
                    child: Text('Upload'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
