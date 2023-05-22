import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaveRequestPage extends StatefulWidget {
  @override
  _LeaveRequestPageState createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _usnController = TextEditingController();
  late TextEditingController _semController = TextEditingController();
  late TextEditingController _reasonController = TextEditingController();
  late TextEditingController _dateController = TextEditingController();

  late User? _user; // Variable to store the logged-in user

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  // Get the logged-in user
  void _getUser() {
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usnController.dispose();
    _semController.dispose();
    _reasonController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _submitLeaveRequest() async {
    String name = _nameController.text;
    String usn = _usnController.text;
    String sem = _semController.text;
    String reason = _reasonController.text;
    String date = _dateController.text;

    // Validate the input fields
    if (name.isEmpty || usn.isEmpty || sem.isEmpty || reason.isEmpty || date.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all the fields.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Check if a user is logged in
    if (_user == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('No user is logged in.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    String userId = _user!.uid; // Get the user's ID

    // Create a leave request object
    Map<String, dynamic> leaveRequest = {
      'userId': userId, // Include the user's ID in the leave request
      'name': name,
      'usn': usn,
      'sem': sem,
      'reason': reason,
      'date': date,
      'status': 'pending', // Initialize the status as pending
    };

    try {
      // Add the leave request to Firestore
      await FirebaseFirestore.instance.collection('leaveRequest').add(leaveRequest);

      // Show a success dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Leave request submitted successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  // Clear the input fields
                  _nameController.clear();
                  _usnController.clear();
                  _semController.clear();
                  _reasonController.clear();
                  _dateController.clear();

                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Show an error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to submit leave request. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
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
        title: Text('Leave Request'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _usnController,
              decoration: InputDecoration(
                labelText: 'USN',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _semController,
              decoration: InputDecoration(
                labelText: 'Semester',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: 'Reason',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date',
              ),
            ),
            SizedBox(height: 16.0),
            Theme(
              data: Theme.of(context).copyWith(
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple, // Set the desired background color here
                  ),
                ),
              ),
              child: ElevatedButton(
                onPressed: _submitLeaveRequest,
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
