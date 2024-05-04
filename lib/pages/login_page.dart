
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:clusteroids/common/theme_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_password_page.dart';
import 'profile_page.dart';
import 'AdminLoginPage.dart';
import 'registration_page.dart';
import 'widgets/header_widget.dart';
import 'teacher_login.dart';
import 'ManagementLogin.dart';


class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}): super(key:key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  double _headerHeight = 250;
  Key _formKey = GlobalKey<FormState>();



  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
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
                        'Hello',
                        style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Signin into your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  controller: _emailController ,
                                  decoration: ThemeHelper().textInputDecoration('User Name', 'Enter your user name'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                margin: EdgeInsets.fromLTRB(10,0,10,20),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPasswordPage()), );
                                  },
                                  child: Text( "Forgot your password?", style: TextStyle( color: Colors.grey, ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text('Sign In'.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                                  ),
                                  onPressed: () async {
                                    String email = _emailController.text.trim();
                                    String password = _passwordController.text.trim();
                                    if ( email.isEmpty || password.isEmpty)
                                      {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Enter Correct Credentials')),
                                        );
                                      }
                                    try {
                                     UserCredential userCredential =  await _auth.signInWithEmailAndPassword(
                                          email: email,
                                           password: password,
                                    );
                                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));

                                      // Login successful, handle the result
                                    } catch (e, stackTrace) {
                                    print('Error logging in: $stackTrace');
                                    // Handle the error appropriately
                                    }
                                  },
                                    //After successful login we will redirect to profile page. Let's create profile page now
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10,20,10,20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(
                                    TextSpan(
                                        children: [
                                          TextSpan(text: "Don\'t have an account? "),
                                          TextSpan(
                                            text: 'Create',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLoginPage()));
                                              },
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent),
                                          ),
                                        ]
                                    )
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: ThemeHelper().buttonBoxDecoration(context),
                                    child: ElevatedButton(
                                      style: ThemeHelper().buttonStyle(),
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                        child: Text('Teacher'.toUpperCase(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),),
                                      ),
                                      onPressed: (){
                                        //After successful login we will redirect to profile page. Let's create profile page now
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeacherLogin()));
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 16), // Add some spacing between the buttons
                                  Container(
                                    decoration: ThemeHelper().buttonBoxDecoration(context),
                                    child: ElevatedButton(
                                      style: ThemeHelper().buttonStyle(),
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                        child: Text('Management'.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),),
                                      ),
                                      onPressed: (){
                                        //After successful login we will redirect to profile page. Let's create profile page now
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManagementLogin()));
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
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