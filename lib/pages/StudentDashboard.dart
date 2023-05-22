import 'package:flutter/material.dart';
import 'Courses.dart';
import 'package:url_launcher/url_launcher.dart';
import 'notes.dart';
import 'studentAssignment.dart';


class StudentDashboard extends StatelessWidget {
  final String url = 'http://library.vtu.ac.in/';
  final String url1 = 'https://www.aicte-india.org/opportunities/students/resources_students';
  final String url2 = 'http://mitt.edu.in/contact-us/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Student Dashboard'),
        backgroundColor: Colors.purple,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCard(Icons.book, 'Courses', context,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StudentCoursesPage()));
                  },
                ),
                _buildCard(Icons.calendar_today, 'Notes', context,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NotesPage()));
                  },
                ),
                _buildCard(Icons.assignment_turned_in, 'Assignments', context,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AssignmentPage()));
                  },),
              ],
            ),

            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCard(Icons.library_books, 'Library', context,
                  onTap: () async {
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                _buildCard(Icons.chat, 'Discussion', context),
                _buildCard(Icons.local_library, 'Resources', context,
                  onTap: () async {
                    if (await canLaunch(url)) {
                      await launch(url1);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCard(Icons.notifications, 'Notifications', context),
                _buildCard(Icons.help, 'Help', context,
                  onTap: () async {
                    if (await canLaunch(url)) {
                      await launch(url2);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                _buildCard(Icons.settings, 'Settings', context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, BuildContext context, {Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 150.0,
        width: MediaQuery.of(context).size.width / 3 - 20,
        decoration: BoxDecoration(
          color: Colors.purpleAccent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50.0,
              color: Colors.white,
            ),
            SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
