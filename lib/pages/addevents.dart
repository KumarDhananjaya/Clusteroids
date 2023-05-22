import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _eventNameController = TextEditingController();
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadEvent() async {
    setState(() {
      _isUploading = true;
    });

    final eventName = _eventNameController.text.trim();
    final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('event_images/${DateTime.now().toIso8601String()}');
    final uploadTask = firebaseStorageRef.putFile(_selectedImage!);

    final snapshot = await uploadTask.whenComplete(() => null);

    if (snapshot.state == firebase_storage.TaskState.success) {
      final imageUrl = await snapshot.ref.getDownloadURL();
      await _addEventToFirestore(eventName, imageUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event added successfully'),
          backgroundColor: Colors.purple,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to upload image. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isUploading = false;
    });
  }

  Future<void> _addEventToFirestore(String eventName, String imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('events').add({
        'eventName': eventName,
        'imageUrl': imageUrl,
      });
    } catch (error) {
      print('Error adding event: $error');
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to add event. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Add Event'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(
                labelText: 'Event Name',
              ),
            ),
            SizedBox(height: 16.0),
            _selectedImage != null
                ? Image.file(
              _selectedImage!,
              height: 200,
              fit: BoxFit.cover,
            )
                : Container(),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: Icon(Icons.camera),
                  label: Text('Take Photo'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: Icon(Icons.photo_library),
                  label: Text('Choose from Gallery'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadEvent,
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,
                padding: EdgeInsets.all(16.0),
              ),
              child: _isUploading ? CircularProgressIndicator() : Text('Add Event'),
            ),

          ],
        ),
      ),
    );
  }
}
