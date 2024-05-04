import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clusteroids/pages/login_page.dart';
import 'package:clusteroids/pages/widgets/header_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'forgot_password_page.dart';
import 'forgot_password_verification_page.dart';
import 'StudentDashboard.dart';
import 'registration_page.dart';
import 'ProfileUpdate.dart';
import 'Management.dart';
import 'TeacherDashboard.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'requestLeave.dart';
import 'viewLeaveStatus.dart';



class ProfilePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>{

  double  _drawerIconSize = 24;
  double _drawerFontSize = 17;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user; // Declare _user as nullable User
  late String _userName;
  late String _email;
  late String _usn;
  late String _mobile;
  late String _cgpa;
  late String _feeStatus;
  late String? _profileImageUrl;

  Future<void> _getUserDetails() async {
    _user = _auth.currentUser;
    if (_user != null) {
      final DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('students').doc(_user!.uid).get();

      setState(() {
        _userName = userSnapshot.get('name');
        _email = userSnapshot.get('email');
        _usn = userSnapshot.get('usn');
        _cgpa = userSnapshot.get('cgpa');
        _mobile = userSnapshot.get('mobile');
        _feeStatus = userSnapshot.get('feeStatus');

      });

      final profileImageRef = FirebaseStorage.instance.ref().child('profilePictures/${_user!.uid}.jpg');
      final profileImageUrl = await profileImageRef.getDownloadURL();

      setState(() {
        _profileImageUrl = profileImageUrl;
      });
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    // Add any additional logout logic here

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged out successfully.'),
      ),
    );

    Navigator.push( context, MaterialPageRoute(builder: (context) => LoginPage()), );

  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace:Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Theme.of(context).primaryColor, Colors.tealAccent,]
              )
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only( top: 16, right: 16,),
            child: Stack(
              children: <Widget>[
                Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration( color: Colors.red, borderRadius: BorderRadius.circular(6),),
                    constraints: BoxConstraints( minWidth: 12, minHeight: 12, ),
                    child: Text( '5', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration:BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 1.0],
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.2),
                    Colors.tealAccent.withOpacity(0.5),
                  ]
              )
          ) ,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    colors: [ Theme.of(context).primaryColor,Colors.tealAccent,],
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text("Clusteroids App",
                    style: TextStyle(fontSize: 25,color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              Divider(color: Theme.of(context).primaryColor, height: 1,),
              ListTile(
                leading: Icon(Icons.dashboard, size: _drawerIconSize,color: Colors.tealAccent,),
                title: Text('Dashboard',style: TextStyle(fontSize: _drawerFontSize,color: Colors.tealAccent),),
                onTap: () {
                  Navigator.push( context, MaterialPageRoute(builder: (context) => StudentDashboard()), );

                },
              ),
              Divider(color: Theme.of(context).primaryColor, height: 1,),
              ListTile(
                leading: Icon(Icons.face, size: _drawerIconSize,color: Colors.tealAccent,),
                title: Text('Profile',style: TextStyle(fontSize: _drawerFontSize,color: Colors.tealAccent),),
                onTap: () {
                  Navigator.push( context, MaterialPageRoute(builder: (context) => ProfilePage()), );

                },
              ),
              Divider(color: Theme.of(context).primaryColor, height: 1,),
              ListTile(
                leading: Icon(Icons.update, size: _drawerIconSize,color: Colors.tealAccent,),
                title: Text('Update Details',style: TextStyle(fontSize: _drawerFontSize,color: Colors.tealAccent),),
                onTap: () {
                  Navigator.push( context, MaterialPageRoute(builder: (context) => ProfileUpdate()), );
                },
              ),
              Divider(color: Theme.of(context).primaryColor, height: 1,),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.request_page,
                  size: _drawerIconSize,
                  color: Colors.tealAccent,
                ),
                title: Text(
                  'Request Leave',
                  style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Colors.tealAccent,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeaveRequestPage()),
                  );
                },
              ),

              // View Requests
              ListTile(
                leading: Icon(
                  Icons.list,
                  size: _drawerIconSize,
                  color: Colors.tealAccent,
                ),
                title: Text(
                  'View Requests',
                  style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Colors.tealAccent,
                  ),
                ),
                onTap: () {
                  Navigator.push( context, MaterialPageRoute(builder: (context) => LeaveRequestListPage()), );
                },
              ),

              Divider(color: Theme.of(context).primaryColor, height: 1,),
              ListTile(
                leading: Icon(Icons.logout, size: _drawerIconSize,color: Colors.tealAccent,),
                title: Text('Logout',style: TextStyle(fontSize: _drawerFontSize,color: Colors.tealAccent),),
                onTap: logout,
              ),
            ],
          ),
        ),
      ),
      body: _user != null
          ? SingleChildScrollView(
        child: Stack(
          children: [
            Container(height: 100, child: HeaderWidget(100,false,Icons.house_rounded),),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 5, color: Colors.white),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                      ],
                    ),
                    child: Icon(Icons.person, size: 80, color: Colors.grey.shade300,),
                  ),

                  SizedBox(height: 20,),
                  Text('$_userName', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
                  Text('Student', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "User Information",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Card(
                          child: Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    ...ListTile.divideTiles(
                                      color: Colors.grey,
                                      tiles: [
                                        ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          leading: Icon(Icons.face),
                                          title: Text("Name"),
                                          subtitle: Text("$_userName"),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.perm_identity),
                                          title: Text("USN"),
                                          subtitle: Text(
                                              "$_usn"),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.email),
                                          title: Text("Email"),
                                          subtitle: Text("$_email"),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.phone),
                                          title: Text("Phone"),
                                          subtitle: Text("$_mobile"),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.school),
                                          title: Text("CGPA"),
                                          subtitle: Text(
                                              "$_cgpa"),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.money),
                                          title: Text("Fee Status"),
                                          subtitle: Text(
                                              "$_feeStatus"),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ):Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}