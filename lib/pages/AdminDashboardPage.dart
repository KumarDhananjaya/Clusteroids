import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'RegisterOptions.dart';
import 'studentlist.dart';
import 'teacherlist.dart';
import 'AdminLoginPage.dart'; // Import the admin login page
import 'analytics.dart';
import 'addevents.dart';


class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Add a function for logging out
  void _logout() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminLoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            onPressed: _logout, // Call the logout function
            icon: Tooltip(
              message: 'Logout',
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCard(
                    context,
                    FontAwesomeIcons.userGraduate,
                    'Students',
                    'View and manage',
                        () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentListPage())),
                  ),
                  _buildCard(
                    context,
                    FontAwesomeIcons.user,
                    'Faculty',
                    'faculty details',
                        () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeacherListPage())),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCard(
                    context,
                    FontAwesomeIcons.solidCalendarAlt,
                    'Events',
                    'Manage events',
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddEventPage()),
                     ),
                  ),
                  _buildCard(
                    context,
                    FontAwesomeIcons.cashRegister,
                    'Register ',
                    'Add users ',
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterOptions())),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCard(
                    context,
                    FontAwesomeIcons.solidCalendarAlt,
                    'Analytics',
                    'View more details',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AnalyticsPage()),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title,
      String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
