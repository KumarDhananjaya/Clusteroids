import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileUpdate extends StatefulWidget {
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final usnController = TextEditingController();
  final cgpaController = TextEditingController();
  final mobileController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future updateProfile() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final String userId = user.uid;

        // Update profile data in Firestore
        await FirebaseFirestore.instance
            .collection('students')
            .doc(userId)
            .update({
          'name': nameController.text,
          'email': emailController.text,
          'usn': usnController.text,
          'cgpa': cgpaController.text,
          'mobile': mobileController.text,
        });

        // Upload profile picture to Firebase Storage
        if (_image != null) {
          Reference storageReference =
          FirebaseStorage.instance.ref().child('profilePictures/$userId');
          UploadTask uploadTask = storageReference.putFile(_image!);
          await uploadTask.whenComplete(() => null);
          String imageUrl = await storageReference.getDownloadURL();

          // Update profile picture URL in Firestore
          await FirebaseFirestore.instance
              .collection('students')
              .doc(userId)
              .update({'profilePicture': imageUrl});
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile. Please try again.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('students').doc(user.uid).get();

        setState(() {
          nameController.text = userSnapshot.get('name');
          emailController.text = userSnapshot.get('email');
          usnController.text = userSnapshot.get('usn');
          cgpaController.text = userSnapshot.get('cgpa');
          mobileController.text = userSnapshot.get('mobile');
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch user details.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    usnController.dispose();
    cgpaController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: usnController,
                decoration: InputDecoration(labelText: 'USN'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: cgpaController,
                decoration: InputDecoration(labelText: 'CGPA'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: mobileController,
                decoration: InputDecoration(labelText: 'Mobile'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.purpleAccent,
                ),
                onPressed: updateProfile,
                child: Text('Update'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.purpleAccent,
                ),
                onPressed: pickImage,
                child: Text('Choose Profile Picture'),
              ),
              SizedBox(height: 20),
              _image != null
                  ? Image.file(
                _image!,
                height: 100,
              )
                  : Text('No image selected.'),
            ],
          ),
        ),
      ),
    );
  }
}
