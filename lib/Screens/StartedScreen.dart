import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login.dart';

class Startedscreen extends StatefulWidget {
  @override
  _StartedscreenState createState() => _StartedscreenState();
}

class _StartedscreenState extends State<Startedscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // يمكنك تغيير الخلفية حسب رغبتك
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ الصورة أولًا
              Image.network(
                '',
              ),
              SizedBox(height: 20),

              // ✅ "TOUR SCAN" تحت الصورة بلون محدد
              Text(
                "TOUR SCAN",
                style: GoogleFonts.anticSlab(
                  fontSize: 64,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFD9CB23), // ✅ اللون الجديد للنص
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
