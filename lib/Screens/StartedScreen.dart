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
                'https://s3-alpha-sig.figma.com/img/2a85/fbe0/53b0aceedeb4e6f0ce22dad31df48379?Expires=1740960000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=iQkLLJNjZ0xYHbFPsJuhPJbie91EKIG3CNVzQjQJOFMClkmuQX-YXSYF-lipeOTJXuSJzdOOw1kZeQYmnt99tADkpBul6K~ngn29qNjqCY84vG6hgBzkhTobWPOnMcAsBQzO2UEebJKLTcmwfBv8eo7RYfp9af-QA-nMdF3YF6IneIq09ymUDufTgSAlDmZNQD2lHdCIFiq5reWcLvbFs69gO9DMrv1KtddvGu4AhIiPtl2wD70m9ZgqnTVAJqQcml3hyekWTiOePcOZcDOQL3f1DDhiTXISWgBmbyEYvPGZ~s6~ovqmoSsykcHmFUNi0IRMTednLEjkYYmDwPciUw__',
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
