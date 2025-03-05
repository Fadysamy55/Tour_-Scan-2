import '../Constans/Const.dart';

class Message {
  final String message;
  final String id; // إضافة id لتحديد المرسل

  Message(this.message, this.id);

  factory Message.fromJson(Map<String, dynamic> jsonData) {
    return Message(
      jsonData[kMessage],
      jsonData['id'], // جلب ID المستخدم من Firestore
    );
  }
}
