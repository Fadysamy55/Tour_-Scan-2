import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // تأكد من تهيئة Firebase بشكل صحيح
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      home: ChatScreen(
        currentUser: 'user1', // قم بتعديل اسم المستخدم حسب الحاجة
        chatPartner: 'user2', // قم بتعديل اسم المستخدم الآخر حسب الحاجة
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String currentUser;
  final String chatPartner;

  const ChatScreen({Key? key, required this.currentUser, required this.chatPartner})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final CollectionReference _messages;

  @override
  void initState() {
    super.initState();
    // تحديد مجموعة الرسائل بناءً على معرف الدردشة الفريد
    _messages = FirebaseFirestore.instance
        .collection('chats')
        .doc(_getChatId())
        .collection('messages');
  }

  // إنشاء معرف محادثة فريد بناءً على أسماء المستخدمين
  String _getChatId() {
    List<String> users = [widget.currentUser, widget.chatPartner];
    users.sort();
    return users.join('_');
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      _messages.add({
        'text': _controller.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'sender': widget.currentUser,
      }).then((_) {
        print("Message sent successfully!");
      }).catchError((error) {
        print("Error sending message: $error");
      });

      _controller.clear();
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatPartner, style: TextStyle(color: Colors.grey[600])),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messages.orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error loading messages"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No messages yet"));
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData = messages[index];
                    bool isMe = messageData['sender'] == widget.currentUser;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Color(0xFF582218) : Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          messageData['text'],
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF582218),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
