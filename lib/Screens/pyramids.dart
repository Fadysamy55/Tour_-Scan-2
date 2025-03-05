import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../MODELS/Postlmodel.dart';


class Pyramids extends StatelessWidget {
  final PostsModel? postsModel;
  const Pyramids({Key? key, this.postsModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // الحصول على أبعاد الشاشة
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(

      body: Stack(
        children: [
          Column(
            children: [
              // النصف العلوي: الصورة مع العنوان
              Container(
                height: screenHeight * 0.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(postsModel!.imgPath!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      postsModel!.title!,
                      style: GoogleFonts.oxanium(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: const Offset(0, -2),
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
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              postsModel!.description!,
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
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.brown[800],
                ),
              ),
            ),
          ),
          Positioned(
            left: (screenWidth / 1.25) - 30,
            top: (screenHeight * 0.5) - 30,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/Vector.png', // استبدل باسم ملف الصورة الصحيح
                width: 30, // تعديل الحجم حسب الحاجة
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
