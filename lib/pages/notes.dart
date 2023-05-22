import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late TextEditingController _searchController;
  List<DocumentSnapshot> _filteredNotes = [];
  List<DocumentSnapshot> _allNotes = [];


  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _getAllNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getAllNotes() async {

    final notesSnapshot =
    await FirebaseFirestore.instance.collection('notes').get();
    setState(() {
      _allNotes = notesSnapshot.docs;
      _filteredNotes = _allNotes;
    });
  }

  void _filterNotes(String query) {
    setState(() {
      _filteredNotes = _allNotes
          .where((note) =>
          note.get('title').toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _launchURL(String url) async {
    if (url != null && url.isNotEmpty) {
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterNotes,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredNotes.length,
              itemBuilder: (context, index) {
                final note = _filteredNotes[index];
                return ListTile(
                  title: Text(note.get('title')),
                  trailing: IconButton(
                    icon: Icon(Icons.download),
                    onPressed: () {
                      _launchURL(note.get('downloadUrl') ?? '');
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
