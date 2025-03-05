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
  bool isLoading = false;
  bool showPassword = false;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _setFakeData(); // تعيين بيانات وهمية عند تشغيل الصفحة
  }

  void _setFakeData() {
    setState(() {
      userData = {
        "fullName": "John Doe",
        "email": "johndoe@example.com",
        "phone": "+201234567890",
        "address": "Cairo, Egypt",
        "age": "25",
        "gender": "Male",
        "profileImage": null, // صورة افتراضية
      };
    });
  }

  void _getUserData() async {
    setState(() => isLoading = true);

    user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>?;
          isLoading = false;
        });
      }
    }
  }

  void _updateUserData(String field, String value) async {
    await _firestore.collection('users').doc(user!.uid).update({field: value});
    setState(() {
      userData![field] = value;
    });
    _showMessage("Profile updated successfully!");
  }

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      _uploadImage();
    }
  }

  void _uploadImage() async {
    if (_imageFile == null) return;

    Reference storageRef =
    FirebaseStorage.instance.ref().child('profile_images/${user!.uid}.jpg');
    await storageRef.putFile(_imageFile!);
    String imageUrl = await storageRef.getDownloadURL();

    _updateUserData('profileImage', imageUrl);
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _deleteAccount() async {
    try {
      await _firestore.collection('users').doc(user!.uid).delete();
      await _auth.currentUser!.delete();
      _showMessage("Account deleted successfully!");
      Navigator.of(context).pushReplacementNamed('/signup');
    } catch (e) {
      _showMessage("Error deleting account: $e");
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: userData!['profileImage'] != null
                      ? NetworkImage(userData!['profileImage'])
                      : AssetImage("assets/profile_placeholder.png")
                  as ImageProvider,
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.brown[800]),
                  onPressed: _pickImage,
                ),
              ],
            ),
            SizedBox(height: 20),

            _buildEditableField("Full Name", "fullName"),
            _buildEditableField("Email", "email"),
            _buildEditableField("Phone", "phone"),
            _buildEditableField("Address", "address"),
            _buildEditableField("Age", "age"),
            _buildEditableField("Gender", "gender"),
            _buildPasswordField(),
            SizedBox(height: 10),

            ElevatedButton(
              onPressed: _getUserData, // تحميل البيانات الحقيقية عند الضغط
              child: Text("Load Real Data"),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _logout,
                child: Text("Logout",
                    style: TextStyle(
                        color: Colors.brown[800],
                        fontWeight: FontWeight.bold)),
              ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: _deleteAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(12),
                ),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, String fieldKey) {
    TextEditingController controller =
    TextEditingController(text: userData![fieldKey].toString());
    bool isEditing = false;

    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            enabled: isEditing,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(isEditing ? Icons.check : Icons.edit,
                    color: Colors.brown[800]),
                onPressed: () {
                  if (isEditing) _updateUserData(fieldKey, controller.text);
                  setState(() => isEditing = !isEditing);
                },
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      );
    });
  }

  Widget _buildPasswordField() {
    TextEditingController passwordController =
    TextEditingController(text: "********");
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Password",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          TextField(
            controller: passwordController,
            obscureText: !showPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.brown[800]),
                onPressed: () => setState(() => showPassword = !showPassword),
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      );
    });
  }
}
