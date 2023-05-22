import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:clusteroids/common/theme_helper.dart';
import 'AdminDashboardPage.dart';
import 'forgot_password_page.dart';
import 'profile_page.dart';
// import 'admin_login_page.dart';
import 'registration_page.dart';
import 'widgets/header_widget.dart';

class AdminLoginPage extends StatefulWidget{
  const AdminLoginPage({Key? key}): super(key:key);

  @override
  _AdminLoginPage createState() => _AdminLoginPage();
}

class _AdminLoginPage extends State<AdminLoginPage>{
  double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true, Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),// This will be the login form
                  child: Column(
                    children: [
                      Text(
                        'Admin',
                        style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Sign in into your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: ThemeHelper().textInputDecoration('User Name', 'Enter your user name'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _email = value!;
                              },
                            ),
                            SizedBox(height: 30.0),
                            TextFormField(
                              decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _password = value!;
                              },
                            ),
                            SizedBox(height: 15.0),
                            Container(
                              decoration: ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    if (_email == 'Admin' && _password == 'Clusteroids') {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Invalid email or password'),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text('Sign In'.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                                ),                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );

  }
}
