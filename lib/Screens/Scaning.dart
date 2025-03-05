
/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class ScanningPage extends StatefulWidget {
  @override
  _ScanningPageState createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  File? _image;
  String _result = "No statue detected yet";

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  // ✅ Load TFLite Model with Error Handling
  Future<void> loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/model/model.tflite",
        labels: "assets/model/labels.txt",
      );
      print("Model Loaded: ${res ?? 'Failed to load model'}");
    } catch (e) {
      print("❌ Error Loading Model: $e");
    }
  }

  // ✅ Classify Image
  Future<void> classifyImage(File image) async {
    try {
      var recognitions = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 3,  // Increase results if multiple objects exist
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
      );

      setState(() {
        _result = recognitions != null && recognitions.isNotEmpty
            ? recognitions.map((r) => "${r['label']} (${(r['confidence'] * 100).toStringAsFixed(2)}%)").join("\n")
            : "Could not recognize the statue";
      });
    } catch (e) {
      print("❌ Error during classification: $e");
      setState(() {
        _result = "Error processing image";
      });
    }
  }

  // ✅ Pick Image
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      classifyImage(_image!);
    }
  }

  @override
  void dispose() {
    Tflite.close(); // ✅ Prevent Memory Leak
    super.dispose();
  }

  // ✅ UI Design
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statue Recognition"),
        backgroundColor: Colors.brown[800],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image != null
              ? Image.file(_image!, height: 200, width: 200, fit: BoxFit.cover)
              : Icon(Icons.image, size: 150, color: Colors.brown[400]),
          SizedBox(height: 20),
          Text(
            _result,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => pickImage(ImageSource.camera),
                icon: Icon(Icons.camera),
                label: Text("Capture Image"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[600]),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () => pickImage(ImageSource.gallery),
                icon: Icon(Icons.image),
                label: Text("Pick from Gallery"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/