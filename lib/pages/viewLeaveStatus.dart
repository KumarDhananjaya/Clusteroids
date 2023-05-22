import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaveRequestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Request List'),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('leaveRequest')
            .where('userId', isEqualTo: user?.uid) // Retrieve requests for the logged-in user only
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final leaveRequests = snapshot.data!.docs;

          if (leaveRequests.isEmpty) {
            return Center(
              child: Text('No leave requests found.'),
            );
          }

          return ListView.builder(
            itemCount: leaveRequests.length,
            itemBuilder: (context, index) {
              final leaveRequest = leaveRequests[index].data() as Map<String, dynamic>;

              Color statusColor = Colors.black;
              if ('${leaveRequest['status']}' == 'accepted') {
                statusColor = Colors.green;
              } else if ('${leaveRequest['status']}'== 'rejected') {
                statusColor = Colors.red;
              }
              return ListTile(
                title: Text('Name: ${leaveRequest['name']}'),
                subtitle: Text('Reason: ${leaveRequest['reason']}'),
                trailing: Text('Status: ${leaveRequest['status']}',
                  style: TextStyle(color: statusColor),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
