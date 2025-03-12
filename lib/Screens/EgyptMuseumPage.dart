import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EgyptMuseumPage extends StatelessWidget {
  final String imgPath;
  final String title;
  final String description;

  const EgyptMuseumPage({
    Key? key,
    required this.imgPath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // الصورة والعنوان
              Container(
                height: screenHeight * 0.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imgPath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      title,
                      style: GoogleFonts.oxanium(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // صندوق الوصف
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, -2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: GoogleFonts.oxanium(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              description,
                              style: GoogleFonts.oxanium(
                                fontSize: 15.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // زر الرجوع
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xFF582218),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// استدعاء الصفحة وتمرير البيانات
class MuseumScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EgyptMuseumPage(
      imgPath: 'assets/16a04dd4bd365e859919801c65f396ab.jpeg',
      title: 'Egyptian Museum',
      description: 'The Egyptian Museum in Cairo (EMC) is the oldest archaeological museum in the Middle East, '
          'housing over 170,000 artefacts. It has the largest collection of Pharaonic antiquities in the world.\n\n'
          'The Museum’s exhibits span the Pre-Dynastic Period till the Graeco-Roman Era (c. 5500 BC - AD 364).',
    );
  }
}
