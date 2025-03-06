import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  User? user;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  File? _imageFile;
  Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
          isLoading = false;
          controllers = {
            'fullName': TextEditingController(text: userData!['fullName']),
            'email': TextEditingController(text: userData!['email']),
            'phoneNumber': TextEditingController(text: userData!['phoneNumber']),
            'address': TextEditingController(text: userData!['address']),
            'age': TextEditingController(text: userData!['age'].toString()),
            'gender': TextEditingController(text: userData!['gender']),
          };
        });
      }
    }
  }

  void _updateAllData() async {
    Map<String, dynamic> updatedData = {};
    controllers.forEach((key, controller) {
      if (controller.text != userData![key]) {
        updatedData[key] = controller.text;
      }
    });

    if (updatedData.isNotEmpty) {
      await _firestore.collection('users').doc(user!.uid).update(updatedData);
      setState(() {
        userData!.addAll(updatedData);
      });
      _showMessage("All data updated successfully!");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildEditableField("Full Name", "fullName"),
            _buildEditableField("Email", "email"),
            _buildEditableField("phoneNumber", "phoneNumber", isNumber: true),
            _buildEditableField("Address", "address"),
            _buildEditableField("Age", "age", isNumber: true),
            _buildEditableField("Gender", "gender"),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: _updateAllData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[800],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              ),
              child: Text("Update Data", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, String fieldKey, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          controller: controllers[fieldKey],
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
