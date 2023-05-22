import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  int studentCount = 0;
  int teacherCount = 0;

  @override
  void initState() {
    super.initState();
    fetchCounts();
  }

  Future<void> fetchCounts() async {
    final studentSnapshot =
    await FirebaseFirestore.instance.collection('students').get();
    final teacherSnapshot =
    await FirebaseFirestore.instance.collection('teachers').get();

    setState(() {
      studentCount = studentSnapshot.docs.length;
      teacherCount = teacherSnapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCountCard(
                  title: 'Students',
                  count: studentCount,
                  color: Colors.deepPurple,
                  icon: Icons.school,
                ),
                _buildCountCard(
                  title: 'Teachers',
                  count: teacherCount,
                  color: Colors.purpleAccent,
                  icon: Icons.person,
                ),
              ],
            ),
            SizedBox(height: 100.0),
            _buildChart(),
          ],
        ),
      ),
    );
  }


  Widget _buildCountCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: color,
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: Colors.white,
            ),
            SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final data = [
      CountData('Students', studentCount, Colors.deepPurple),
      CountData('Teachers', teacherCount, Colors.purpleAccent),
    ];

    final series = [
      charts.Series(
        id: 'Counts',
        data: data,
        domainFn: (CountData count, _) => count.category,
        measureFn: (CountData count, _) => count.count,
        colorFn: (CountData count, _) => count.color,
      ),
    ];

    return Container(
      height: 200.0,
      child: charts.BarChart(
        series,
        animate: true,
      ),
    );
  }
}

class CountData {
  final String category;
  final int count;
  final charts.Color color;

  CountData(this.category, this.count, Color color)
      : this.color = charts.Color(
    r: color.red,
    g: color.green,
    b: color.blue,
    a: color.alpha,
  );
}
