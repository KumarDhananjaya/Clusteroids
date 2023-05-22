import 'package:flutter/material.dart';

class StudentCoursesPage extends StatelessWidget {
  final List<String> courses = [
    'M-3',
    'Data Structures and Applications	',
    'Analog and Digital Electronics	',
    'Computer Organization and Architecture	',
    'OOP with JAVA Laboratory	',
    'Social Connect and Responsibility',
    'Samskrutika Kannada',
    'Balake Kannada	',
    '	Constitution of India and Professional Ethics',
    'Additional Mathematics - I',
    'Mastering Office	',
    'Programming IN c++	',

    'Design and Analysis of Algorithms',
    '	Operating Systems',
    'Microcontroller and Embedded Systems',
    'Object Oriented Concepts	',
    'Data Communication',
    'Design and Analysis of Algorithm Lab',
    'Microcontroller and Embedded Systems Lab',
    'Vyavaharika Kannada	',
    '	Aadalitha Kannada',
    'ADDITIONAL MATHEMATICS – II',
    'Management, Entrepreneurship for IT idustry',
    'Computer Networks and Security',
    '	Database Management System',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Courses Available'),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Card(
                elevation: 5.0,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        courses[index],
                        style: TextStyle(fontSize: 13.0),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          // TODO: Navigate to course details page.
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
