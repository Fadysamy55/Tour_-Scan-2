import 'package:flutter/material.dart';

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  List<Map<String, String>> chatMessages = [
    {"sender": "bot", "message": "How can I help you?"},
  ];

  final List<Map<String, String>> questionsAndAnswers = [
    {"question": "What are the most famous tourist attractions in Egypt?", "answer": "The Pyramids of Giza, the Sphinx, the Valley of the Kings, and the Karnak Temple are among the most famous."},
    {"question": "How can I visit the Pyramids of Giza?", "answer": "You can take a taxi, a bus, or a guided tour from Cairo to the Pyramids."},
    {"question": "What is the best time to visit Egypt?", "answer": "The best time to visit Egypt is from October to April when the weather is cooler."},
    {"question": "Do I need a visa to enter Egypt?", "answer": "Most travelers need a visa, which can be obtained upon arrival or online via the e-visa system."},
    {"question": "Is Egypt safe for tourists?", "answer": "Yes, Egypt is generally safe for tourists, especially in major tourist areas."},
    {"question": "Can I take pictures inside the pyramids?", "answer": "Photography is allowed outside, but inside most pyramids, you need a special permit."},
    {"question": "What currency is used in Egypt?", "answer": "The official currency of Egypt is the Egyptian Pound (EGP)."},
  ];

  TextEditingController messageController = TextEditingController();
  ScrollController _scrollController = ScrollController(); // لتمرير المحادثة تلقائيًا

  void sendMessage(String question) {
    setState(() {
      chatMessages.add({"sender": "user", "message": question});
      final answer = questionsAndAnswers.firstWhere(
            (q) => q["question"] == question,
        orElse: () => {"answer": "Sorry, I couldn't recognize your question."},
      )["answer"]!;
      chatMessages.add({"sender": "bot", "message": answer});
    });
    messageController.clear();
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ChatBot",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0, // إزالة الظل من الـ AppBar
      ),
      backgroundColor: Colors.white, // جعل الخلفية بيضاء بالكامل
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              itemCount: chatMessages.length,
              separatorBuilder: (context, index) => SizedBox(height: 5),
              itemBuilder: (context, index) {
                final message = chatMessages[index];
                bool isUser = message["sender"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isUser ? Color(0xFF582218) : Colors.grey[300], // السؤال بني غامق - الإجابة رمادي فاتح
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      message["message"]!,
                      style: TextStyle(
                        fontSize: 16, // جعل النص أكبر
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Popular Questions:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: questionsAndAnswers.map((qna) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF582218), // اللون البني الغامق للأسئلة
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => sendMessage(qna["question"]!),
                      child: Text(
                        qna["question"]!,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Type your question...",
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF582218)!),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF582218)!),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onSubmitted: (text) {
                          if (text.trim().isNotEmpty) {
                            sendMessage(text.trim());
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Color(0xFF582218)),
                      onPressed: () {
                        if (messageController.text.trim().isNotEmpty) {
                          sendMessage(messageController.text.trim());
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
