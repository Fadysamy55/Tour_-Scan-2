import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _obscurePassword = true;
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
            'password': TextEditingController(text: "********"),
          };
        });
      }
    }
  }

  void _updateAllData() async {
    Map<String, dynamic> updatedData = {};
    controllers.forEach((key, controller) {
      if (key != 'password' && controller.text != userData![key]) {
        updatedData[key] = controller.text;
      }
    });

    if (controllers['password']!.text != "********") {
      try {
        await user!.updatePassword(controllers['password']!.text);
        updatedData['password'] = controllers['password']!.text;
      } catch (e) {
        _showMessage("Failed to update password: $e", isError: true);
        return;
      }
    }

    if (updatedData.isNotEmpty) {
      await _firestore.collection('users').doc(user!.uid).update(updatedData);
      setState(() {
        userData!.addAll(updatedData);
      });
      _showMessage("All data updated successfully!");
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: isError ? Colors.red : Colors.green),
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
            _buildEditableField("Phone Number", "phoneNumber", isNumber: true),
            _buildEditableField("Address", "address"),
            _buildEditableField("Age", "age", isNumber: true),
            _buildEditableField("Gender", "gender"),
            _buildPasswordField(),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: _updateAllData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF582218),
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

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          controller: controllers['password'],
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
