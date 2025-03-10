import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ScanningPage extends StatefulWidget {
  @override
  _ScanningPageState createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  File? _image;
  String _result = "No statue detected yet";
  Interpreter? _interpreter;
  List<String> _labels = [];
  final double _confidenceThreshold = 60.0;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model/model.tflite');
      print("✅ Model Loaded Successfully");
      loadLabels();
    } catch (e) {
      print("❌ Error Loading Model: $e");
    }
  }

  Future<void> loadLabels() async {
    try {
      String labelsData = await DefaultAssetBundle.of(context).loadString('assets/model/labels.txt');
      setState(() {
        _labels = labelsData.split('\n').where((label) => label.isNotEmpty).toList();
      });
      print("✅ Labels Loaded: ${_labels.length}");
    } catch (e) {
      print("❌ Error Loading Labels: $e");
    }
  }

  Future<List<List<List<double>>>> preprocessImage(File imageFile) async {
    final img.Image? image = img.decodeImage(await imageFile.readAsBytes());

    if (image == null) {
      throw Exception("❌ Failed to decode image");
    }

    final img.Image resized = img.copyResize(image, width: 224, height: 224);

    List<List<List<double>>> input = List.generate(
      224,
          (y) => List.generate(
        224,
            (x) {
          final img.Pixel pixel = resized.getPixelSafe(x, y);

          double red = pixel.r / 255.0;
          double green = pixel.g / 255.0;
          double blue = pixel.b / 255.0;

          return [red, green, blue];
        },
      ),
    );

    return input;
  }

  Future<void> classifyImage(File image) async {
    if (_interpreter == null || _labels.isEmpty) {
      print("❌ Model not loaded yet!");
      return;
    }

    List<List<List<double>>> inputImage = await preprocessImage(image);
    List<List<double>> output = List.generate(1, (_) => List.filled(_labels.length, 0));

    _interpreter!.run([inputImage], output);

    int maxIndex = output[0].indexWhere((val) => val == output[0].reduce((a, b) => a > b ? a : b));
    double confidence = output[0][maxIndex] * 100;

    setState(() {
      if (confidence >= _confidenceThreshold) {
        _result = "Detected: ${_labels[maxIndex]} (${confidence.toStringAsFixed(2)}%)";
      } else {
        _result = "❌ Statue not recognized.";
      }
    });

    print("📸 Classification Result: $_result");
  }

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
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Statue Recognition",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Color(0xFF582218),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image != null
              ? Image.file(_image!, height: 200, width: 200, fit: BoxFit.cover)
              : Icon(Icons.image, size: 150, color: Color(0xFF582218)),
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
                icon: Icon(Icons.camera, color: Colors.white),
                label: Text("Capture Image", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF582218)),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () => pickImage(ImageSource.gallery),
                icon: Icon(Icons.image, color: Colors.white),
                label: Text("Pick from Gallery", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF582218)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
