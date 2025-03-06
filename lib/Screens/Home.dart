import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_card/image_card.dart';
import 'package:tourscan/Screens/pyramids.dart';


import '../MODELS/Postlmodel.dart';
import '../main.dart';
import 'About.dart';
import 'Login.dart';
import 'Setting.dart';
import 'StartedScreen.dart';
import 'chat list screen.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  var _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<PostsModel> postsModel = [];
  List<PostsModel> allModel = [];

  @override
  void initState() {
    super.initState();
    getPlaces();
  }
  Future<void> importJsonToFirestore() async {
    try {
      // Load JSON file from assets
      String jsonString = await rootBundle.loadString('assets/st.json');
      List<dynamic> jsonData = json.decode(jsonString);

      // Reference to Firestore collection
      CollectionReference usersRef = FirebaseFirestore.instance.collection('Statues');

      // Upload data to Firestore
      for (var item in jsonData) {
        await usersRef.add(item);
      }

      print("JSON data successfully imported!");
    } catch (e) {
      print("Error importing JSON: $e");
    }
  }
  getPlaces() async {
    try {
      // QuerySnapshot querySnapshot = await _firestore.collection('places').get();
      //
      // if (querySnapshot.docs.isNotEmpty) {
      //   for (int i = 0; i < querySnapshot.docs.length; i++) {
      //     // استخدم map للتحقق من وجود الحقول المطلوبة
      //     Map<String, dynamic> data = querySnapshot.docs[i].data() as Map<String, dynamic>;
      //     String country = data.containsKey('country') ? data['country'] : 'Unknown';
      //     String image = data.containsKey('image') ? data['image'] : '';
      //     String title = data.containsKey('title') ? data['title'] : '';
      //     String description = data.containsKey('description') ? data['description'] : '';
      //
      //     QuerySnapshot querySnapshotFav = await FirebaseFirestore.instance
      //         .collection('fav')
      //         .where('user_id', isEqualTo: sharedpref!.getString('uid'))
      //         .where('post_id', isEqualTo: querySnapshot.docs[i].id)
      //         .get();
      //     bool isFav = querySnapshotFav.size > 0;
      //
      //     PostsModel post = PostsModel(
      //         id: querySnapshot.docs[i].id,
      //         name: country,
      //         imgPath: image,
      //         title: title,
      //         isFav: isFav,
      //         description: description,
      //         isPlaces: true);
      //     postsModel.add(post);
      //     allModel.add(post);
      //
      //     print('data: $country');
      //   }
      //  setState(() {});

        QuerySnapshot querySnapshotStatues =
        await _firestore.collection('Statues').get();
        await _firestore.collection('Artifacts').get();

        if (querySnapshotStatues.docs.isNotEmpty) {
          for (int x = 0; x < querySnapshotStatues.docs.length; x++) {
            Map<String, dynamic> statueData =
            querySnapshotStatues.docs[x].data() as Map<String, dynamic>;
                PostsModel post = PostsModel(
                    id: querySnapshotStatues.docs[x].id,
                    name: '',
                    imgPath: statueData.containsKey('image') ? statueData['image'] : '',
                    title: statueData.containsKey('title') ? statueData['title'] : '',
                    isFav: false,
                    description: statueData.containsKey('description')
                        ? statueData['description']
                        : '',
                    isPlaces: false);
           // allModel.add(post);
            postsModel.add(post);

            setState(() {

            });
            print('nums');
            print(postsModel.length.toString());
            print(allModel.length.toString());

          }
        }
      // }
    } catch (e) {
      print('error_' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Image.asset(
              'assets/menu.png', // مسار الصورة
              width: 26, // تعديل الحجم حسب الحاجة
              height: 26,
              fit: BoxFit.contain,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),

        title: Container(
          width: 220,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            textAlign: TextAlign.start,
            onChanged: (val) async {
              postsModel.clear();
              if (val.isEmpty) {
                getPlaces();
              } else {
                postsModel.addAll(allModel.where((searchItem) =>
                    searchItem.title!
                        .toLowerCase()
                        .contains(val.toLowerCase())));
              }
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(color: Colors.brown.shade900),
              suffixIcon: Icon(Icons.search, color: Colors.brown.shade900),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding:
              EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Text(
              "Login",
              style: TextStyle(
                  color: Color(0xFF582218), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      drawer:Drawer(
        child: Column(
          children: [
            Container(
              color: Colors.white, // جعل الخلفية بالكامل بيضاء
              padding: EdgeInsets.only(top: 50, bottom: 20), // مسافة علوية وسفلية
              child: Column(
                children: [
                  // صورة الحساب
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 70, // تكبير الخلفية
                        backgroundImage: AssetImage("assets/profile1.png"), // الخلفية
                      ),
                      CircleAvatar(
                        radius: 50, // تصغير الصورة فوق الخلفية
                        backgroundColor: Colors.transparent, // إزالة أي لون خلفي
                        backgroundImage: AssetImage("assets/profile2.png"), // الصورة الشخصية
                      ),
                    ],
                  ),
                  SizedBox(height: 15), // مسافة بعد الصورة

                  // اسم المستخدم
                  Text(
                    "User Name",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5), // مسافة بين الاسم والإيميل

                  // الإيميل
                  Text(
                    "user@example.com",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(height: 15), // مسافة قبل الخط الفاصل

                  // الخط الفاصل الرمادي
                  Divider(
                    thickness: 1,
                    color: Colors.grey.shade300,
                    indent: 30,
                    endIndent: 30,
                  ),
                ],
              ),
            ),

            // القائمة الرئيسية
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.home, color: Color(0xFF582218)),
                    title: Text("Home"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: Color(0xFF582218)),
                    title: Text("Settings"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                    },
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/rocketchat-brands-solid 1.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    title: Text("Ask"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatListScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info, color: Color(0xFF582218)),
                    title: Text("About"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
                    },
                  ),
                ],
              ),
            ),

            // زر تسجيل الخروج في الأسفل
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(Icons.logout, color: Color(0xFF582218)),
                title: Text("Logout"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Startedscreen()));
                },
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome To Tour Scan",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF582218)),
              ),
              SizedBox(height: 5),
              Text(
                "Find your Next Adventure",
                style:
                TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              SizedBox(height: 20),
              Stack(
                children: [
                  // الصورة مع زوايا دائرية
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25), // زوايا دائرية قوية
                    child: SizedBox(
                      width: 538,
                      height: 227,
                      child: Image.asset("assets/16a04dd4bd365e859919801c65f396ab.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // النصوص داخل مستطيل شفاف
                  Positioned(
                    bottom: 10, // وضع النصوص قرب أسفل الصورة
                    left: 20,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black26, // تفتيح الخلفية أكثر لجعلها ناعمة
                        borderRadius: BorderRadius.circular(12), // زوايا ناعمة
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // المحاذاة لليسار
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Egyptian Museum',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white, // العنوان بالأبيض
                            ),
                          ),
                          Text(
                            'Egypt, Giza',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[300], // لون أفتح قليلاً
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              // بقية الكود الخاص بعرض الـ Category و Explore...
              Text(
                "Artifacts",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF582218)),
              ),
              Container(
                width: 300,
                height: 196,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white70,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: postsModel.length,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection('history')
                              .doc()
                              .set({
                            'post_id': postsModel[index].id!,
                            'user_id': sharedpref!.getString('uid'),
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Pyramids(postsModel: postsModel[index]),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FillImageCard(
                            width: 200,
                            heightImage: 100,
                            color: Colors.grey.shade300,
                            imageProvider:
                            NetworkImage(postsModel[index].imgPath!),
                            description: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      postsModel[index].name!,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context)
                                          .width *
                                          .22,
                                      child: Text(
                                        postsModel[index].title!,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(height: 20),
              Text(
                "Statues",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF582218)),
              ),
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: postsModel.length,
                  padding: EdgeInsets.symmetric(vertical: 9),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection('history')
                            .doc()
                            .set({
                          'post_id': postsModel[index].id!,
                          'user_id': sharedpref!.getString('uid'),
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Pyramids(postsModel: postsModel[index]),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    postsModel[index].imgPath!,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        postsModel[index].name!,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        postsModel[index].title!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios,
                                      color: Colors.black54),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('history')
                                        .doc()
                                        .set({
                                      'post_id': postsModel[index].id!,
                                      'user_id': sharedpref!.getString('uid'),
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Pyramids(
                                                postsModel:
                                                postsModel[index]),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Colors.grey.shade400),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:Color(0xFF582218),
              fixedSize: Size(60, 60),
              padding: EdgeInsets.zero, // إزالة الـ padding الافتراضي
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/Group.png', // مسار الصورة
                width: 35, // تعديل الحجم حسب الحاجة
                height: 35,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }
}

