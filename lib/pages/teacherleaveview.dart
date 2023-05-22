import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveRequestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Request List'),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('leaveRequest').snapshots(),
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
              if (leaveRequest['status'] == 'accepted') {
                statusColor = Colors.green;
              } else if (leaveRequest['status'] == 'rejected') {
                statusColor = Colors.red;
              }

              return ListTile(
                title: Text('Name: ${leaveRequest['name']}'),
                subtitle: Text('Reason: ${leaveRequest['reason']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check),
                      color: Colors.green,
                      onPressed: () {
                        _updateLeaveRequestStatus(leaveRequests[index].reference, 'accepted');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Request Accepted')),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      color: Colors.red,
                      onPressed: () {
                        _updateLeaveRequestStatus(leaveRequests[index].reference, 'rejected');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Request Rejected')),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _updateLeaveRequestStatus(DocumentReference documentRef, String status) {
    documentRef.update({'status': status})
        .then((value) => print('Leave request status updated.'))
        .catchError((error) => print('Failed to update leave request status: $error'));
  }
}
