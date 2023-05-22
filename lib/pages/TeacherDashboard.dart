import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'assignments.dart';
import 'teacherleaveview.dart';

class TeacherDashboard extends StatefulWidget {
  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _selectedIndex = 0;
  final List<Widget> _teacherPages = [ViewStudent(), Notes(), Notices()];
  bool _isLoading = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged out'),
        ),
      );


      Navigator.pushReplacementNamed(context, '/'); // Replace '/login' with your login screen route
    } catch (e) {
      print('Sign-out failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard'),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _teacherPages[_selectedIndex],
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Assignments'),
              onTap: () {
                Navigator.push( context, MaterialPageRoute( builder: (context) => AssignmentsPage()), );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Leave Requests'),
              onTap: () {
                Navigator.push( context, MaterialPageRoute( builder: (context) => LeaveRequestListPage()), );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _signOut,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _isLoading = true;
          });

          // Simulate a delay for loading content
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _isLoading = false;
            });
          });
        },
      ),
    );
  }
}



class ViewStudent extends StatefulWidget {
  @override
  _ViewStudentState createState() => _ViewStudentState();
}

class _ViewStudentState extends State<ViewStudent> {
  late List<DocumentSnapshot> allStudents;
  late List<DocumentSnapshot> displayedStudents;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    final snapshot = await FirebaseFirestore.instance.collection('students').get();
    setState(() {
      allStudents = snapshot.docs;
      displayedStudents = allStudents;
    });
  }

  void searchStudents(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedStudents = allStudents;
      });
    } else {
      final List<DocumentSnapshot> searchResults = allStudents.where((student) {
        final studentName = student['name'].toString().toLowerCase();
        final studentUsn = student['usn'].toString().toLowerCase();
        return studentName.contains(query.toLowerCase()) || studentUsn.contains(query.toLowerCase());
      }).toList();
      setState(() {
        displayedStudents = searchResults;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: searchStudents,
            decoration: InputDecoration(
              hintText: 'Search students...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: displayedStudents.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot student = displayedStudents[index];
              final studentName = student['name'];
              final studentUsn = student['usn'];
              final studentCgpa = student['cgpa'];
              final feeStatus = student['feeStatus'];

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      studentName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    studentName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        'USN: $studentUsn',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'CGPA: $studentCgpa',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Fee Status: $feeStatus',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final TextEditingController _noteController = TextEditingController();
  late List<DocumentSnapshot> allNotes;
  late List<DocumentSnapshot> displayedNotes;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('notes').get();
    setState(() {
      allNotes = snapshot.docs;
      displayedNotes = allNotes;
    });
  }

  void searchNotes(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedNotes = allNotes;
      });
    } else {
      final List<DocumentSnapshot> searchResults = allNotes.where((note) {
        final noteTitle = note['title'].toString().toLowerCase();
        return noteTitle.contains(query.toLowerCase());
      }).toList();
      setState(() {
        displayedNotes = searchResults;
      });
    }
  }

  Future<void> addNote() async {
    final String noteTitle = _noteController.text.trim();

    if (noteTitle.isNotEmpty) {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        final File file = File(result.files.first.path!);

        final CollectionReference notesRef =
        FirebaseFirestore.instance.collection('notes');
        final String noteId = DateTime.now().millisecondsSinceEpoch.toString();

        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('notes')
            .child('$noteId.pdf');
        final UploadTask uploadTask = storageReference.putFile(file);
        final TaskSnapshot storageSnapshot =
        await uploadTask.whenComplete(() => null);
        final String downloadUrl = await storageSnapshot.ref.getDownloadURL();

        await notesRef.doc(noteId).set({
          'title': noteTitle,
          'fileUrl': downloadUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Note added successfully.'),
          ),
        );

        _noteController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a PDF file.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a note title.'),
        ),
      );
    }
  }

  Future<void> deleteNote(String noteId) async {
    final CollectionReference notesRef =
    FirebaseFirestore.instance.collection('notes');

    final bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Note'),
        content: Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete != null && confirmDelete) {
      await notesRef.doc(noteId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note deleted.'),
        ),
      );
    }
  }

  // Future<void> downloadNote(String noteUrl) async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final savePath = '${directory.path}/note.pdf';
  //
  //     final dio = Dio();
  //     await dio.download(noteUrl, savePath);
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Note  downloaded successfully.'),
  //       ),
  //     );
  //
  //     // Open the downloaded note using a PDF viewer or any other appropriate application
  //     // You can use packages like 'flutter_pdfview' or 'url_launcher' to open the PDF file
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to download the note.'),
  //       ),
  //     );
  //   }
  // }



  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    hintText: 'Enter notes title...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: addNote,
                child: Text('Add Notes'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).accentColor,
                  // Use the app theme's accent color
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: searchNotes,
            decoration: InputDecoration(
              hintText: 'Search notes...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: displayedNotes.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot note = displayedNotes[index];
              final noteTitle = note['title'];
              final noteId = note.id;
              final noteUrl = note['fileUrl'];

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  title: Text(
                    noteTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // IconButton(
                      //   icon: Icon(Icons.download),
                      //   onPressed: () => downloadNote(noteUrl),
                      // ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteNote(noteId),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


class Notices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('events').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: Text('No events found'),
          );
        }

        final events = snapshot.data!.docs;

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            final eventName = event['eventName'];
            final eventImage = event['imageUrl'];

            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: eventImage != null
                    ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(imageUrl: eventImage),
                      ),
                    );
                  },
                  child: Image.network(
                    eventImage,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                )
                    : Container(),
                title: Text(eventName),
              ),
            );
          },
        );
      },
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}


