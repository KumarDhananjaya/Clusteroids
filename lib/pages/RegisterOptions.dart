import 'package:flutter/material.dart';
import 'Courses.dart';
import 'registration_page.dart';
import 'teacherregistration.dart';

class RegisterOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add User'),
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
                _buildCard(Icons.person, 'Student', context,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                  },
                ),
                _buildCard(Icons.calendar_today, 'Teacher', context,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherRegistrationPage()));
                  },
                ),
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
