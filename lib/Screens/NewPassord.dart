import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Widgets/Customtext.dart';
import '../widgets/custom_button.dart';
import '../helper/show_snack_bar.dart';
import 'Login.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;
  NewPasswordScreen({required this.email});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  String? newPassword;
  String? confirmPassword;
  bool isLoading = false;
  bool isButtonEnabled = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> updatePassword() async {
    if (formKey.currentState!.validate()) {
      if (newPassword != confirmPassword) {
        showsnackbar(context, "Passwords do not match");
        return;
      }

      setState(() => isLoading = true);

      try {
        // 🔍 التحقق مما إذا كان الإيميل مسجلاً في Firebase
        List<String> signInMethods =
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(widget.email);
        if (signInMethods.isEmpty) {
          showsnackbar(context, "Email is not registered");
          setState(() => isLoading = false);
          return;
        }

        // 🔄 إعادة تسجيل دخول المستخدم لتحديث كلمة المرور
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          showsnackbar(context, "User is not logged in");
          setState(() => isLoading = false);
          return;
        }

        // 🔑 تحديث كلمة المرور
        await user.updatePassword(newPassword!);
        showsnackbar(context, 'Password changed successfully');

        // ⏩ توجيه المستخدم إلى شاشة تسجيل الدخول
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      } on FirebaseAuthException catch (e) {
        showsnackbar(context, 'Error: ${e.message}');
      } catch (e) {
        showsnackbar(context, 'Something went wrong');
      }

      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Text(
                "New Password",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "Enter your new password below",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 40),

              /// 🔑 إدخال كلمة المرور الجديدة
              CustomFormTextField(
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    newPassword = value;
                    isButtonEnabled =
                        value.isNotEmpty && confirmPassword != null;
                  });
                },
                labelText: 'New Password',
                hintText: '',
              ),
              SizedBox(height: 20),

              /// 🔐 تأكيد كلمة المرور الجديدة
              CustomFormTextField(
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value;
                    isButtonEnabled =
                        value.isNotEmpty && newPassword != null;
                  });
                },
                labelText: 'Confirm Password',
                hintText: '',
              ),
              SizedBox(height: 20),

              /// 🔘 زر تغيير كلمة المرور
              GestureDetector(
                onTap: isButtonEnabled ? updatePassword : null,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isButtonEnabled ? Colors.brown : Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Update Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              /// 🔙 الرجوع إلى تسجيل الدخول
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Back to ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
