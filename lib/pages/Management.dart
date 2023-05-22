import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class CollegeManagement extends StatefulWidget {
  @override
  _CollegeManagementState createState() => _CollegeManagementState();
}

class _CollegeManagementState extends State<CollegeManagement> {
  int _selectedIndex = 0;
  final List<Widget> _studentPages = [StudentSchedule(), Fees(), Notifications()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _logout, // Call the logout function
            icon: Tooltip(
              message: 'Logout',
              child: Icon(Icons.logout),
            ),
          ),
        ],
        title: Text('College Management'),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: _studentPages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Fees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class StudentSchedule extends StatefulWidget {
  @override
  _StudentScheduleState createState() => _StudentScheduleState();
}

class _StudentScheduleState extends State<StudentSchedule> {
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
              final student = displayedStudents[index];
              final studentName = student['name'];
              final studentUsn = student['usn'];
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



class Fees extends StatefulWidget {
  @override
  _FeesState createState() => _FeesState();
}

class _FeesState extends State<Fees> {
  final TextEditingController _usnController = TextEditingController();
  bool _isPaid = false;

  void updateFeeStatus() {
    final String usn = _usnController.text.trim();

    if (usn.isNotEmpty) {
      final CollectionReference studentsRef =
      FirebaseFirestore.instance.collection('students');

      studentsRef
          .where('usn', isEqualTo: usn)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.length > 0) {
          final studentDoc = snapshot.docs.first;
          studentsRef
              .doc(studentDoc.id)
              .update({'feeStatus': _isPaid ? 'paid' : 'unpaid'});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fee status updated successfully.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Student not found.'),
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid USN.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _usnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: _usnController,
              decoration: InputDecoration(
                labelText: 'USN',
                filled: true,
                fillColor: Colors.purple.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isPaid = true;
                  });
                  updateFeeStatus();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32),
                ),
                child: Text('Paid'),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isPaid = false;
                  });
                  updateFeeStatus();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32),
                ),
                child: Text('Unpaid'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class Notifications extends StatelessWidget {
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

