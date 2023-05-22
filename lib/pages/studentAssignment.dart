import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class Assignment {
  final String id;
  final String title;
  final String semester;
  final String downloadUrl;

  Assignment({
    required this.id,
    required this.title,
    required this.semester,
    required this.downloadUrl,
  });
}

class AssignmentPage extends StatefulWidget {
  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  late TextEditingController _searchController;
  List<Assignment> _filteredAssignments = [];
  List<Assignment> _allAssignments = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _getAllAssignments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getAllAssignments() async {
    final assignmentsSnapshot =
    await FirebaseFirestore.instance.collection('assignments').get();

    setState(() {
      _allAssignments = assignmentsSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Assignment(
          id: doc.id,
          title: data['title'] ?? '',
          semester: data['semester'] ?? '',
          downloadUrl: data['downloadUrl'] ?? '',
        );
      }).toList();
      _filteredAssignments = _allAssignments;
    });
  }

  void _filterAssignments(String query) {
    setState(() {
      _filteredAssignments = _allAssignments.where((assignment) {
        final title = assignment.title.toLowerCase();
        final semester = assignment.semester.toLowerCase();
        final searchQuery = query.toLowerCase();
        return title.contains(searchQuery) || semester.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to launch the URL.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
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
        title: Text('Assignments'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterAssignments,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredAssignments.length,
              itemBuilder: (context, index) {
                final assignment = _filteredAssignments[index];
                return ListTile(
                  title: Text(assignment.title),
                  subtitle: Text(assignment.semester),
                  trailing: IconButton(
                    icon: Icon(Icons.download),
                    onPressed: () {
                      _launchURL(assignment.downloadUrl);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
