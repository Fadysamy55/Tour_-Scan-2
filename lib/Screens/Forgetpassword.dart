import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourscan/Screens/NewPassord.dart';
import '../Widgets/Customtext.dart';
import '../helper/show_snack_bar.dart';
import 'Login.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  String? email;
  bool isLoading = false;
  bool isButtonEnabled = false; // الزرار يفضل غير مفعل حتى إدخال الإيميل
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> resetPassword() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        // ✅ التحقق من أن البريد الإلكتروني موجود في Firebase
        var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email!.trim());
        if (methods.isEmpty || !methods.contains("password")) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewPasswordScreen(email: 'Mohamed@gmail.com')));

          showsnackbar(context, 'Email not found or does not support password reset.');
          setState(() => isLoading = false);
          return;
        }

        // ✅ إرسال رابط إعادة تعيين كلمة المرور
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email!.trim());
        showsnackbar(context, 'Check your email for the reset link.');

      } on FirebaseAuthException catch (e) {
        showsnackbar(context, 'Error: ${e.message}');
      } catch (e) {
        showsnackbar(context, 'Something went wrong.');
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
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "Enter your registered email below",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 40),

              /// 📧 إدخال البريد الإلكتروني
              CustomFormTextField(
                obscureText: false,
                onChanged: (value) {
                  setState(() {
                    email = value;
                    isButtonEnabled = value.isNotEmpty;
                  });
                },
                labelText: 'Email Address',
                hintText: '',
              ),
              SizedBox(height: 20),

              /// 🔘 زر إرسال رابط إعادة تعيين كلمة المرور
              GestureDetector(
                onTap: isButtonEnabled ? resetPassword : null,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isButtonEnabled ? Color(0xFF582218) : Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Submit",
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
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Remember the password? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(color: Color(0xFF582218), fontWeight: FontWeight.bold),
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
