import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../MODELS/AuthService.dart';
import '../Widgets/Customtext.dart';
import '../helper/show_snack_bar.dart';
import '../widgets/custom_button.dart';
import 'Forgetpassword.dart';
import 'Register.dart';
import 'Setting.dart';
import 'chat list screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? email, password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Login to your account",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    "Welcome back! Please enter your details.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text("Email Address", style: TextStyle(color: Colors.black)),
                  const SizedBox(height: 6),
                  CustomFormTextField(
                    hintText: 'Enter your email',
                    obscureText: false,
                    onChanged: (data) => email = data,
                    labelText: 'Email',
                  ),
                  const SizedBox(height: 16),

                  Text("Password", style: TextStyle(color: Colors.black)),
                  const SizedBox(height: 6),
                  CustomFormTextField(
                    hintText: 'Enter your password',
                    obscureText: true,
                    onChanged: (data) => password = data,
                    labelText: 'Password',
                  ),
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetPasswordScreen()),
                        );
                      },
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(
                          color: Colors.brown,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  CustomButton(
                    text: "LOGIN",
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => isLoading = true);
                        try {
                          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email!,
                            password: password!,
                          );
                          User? user = userCredential.user;

                          if (user != null) {
                            DocumentSnapshot userDoc = await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .get();

                            if (!userDoc.exists) {
                              await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                                'uid': user.uid,
                                'email': user.email,
                                'createdAt': FieldValue.serverTimestamp(),
                              });
                            }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => SettingsPage()),
                            );
                          }
                        } on FirebaseAuthException catch (ex) {
                          if (ex.code == 'user-not-found') {
                            showsnackbar(context, 'User not found');
                          } else if (ex.code == 'wrong-password') {
                            showsnackbar(context, 'Wrong password');
                          }
                        } catch (ex) {
                          showsnackbar(context, 'There was an error');
                        }
                        setState(() => isLoading = false);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        setState(() => isLoading = true);
                        AuthService authService = AuthService();
                        User? user = await authService.signInWithGoogle();

                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatListScreen()),
                          );
                        } else {
                          showsnackbar(context, 'Google Sign-In failed');
                        }
                        setState(() => isLoading = false);
                      },
                      icon: Image.asset(
                        "assets/google_logo.png",
                        height: 24,
                      ),
                      label: const Text(
                        "Sign in with Google",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?",
                          style: TextStyle(color: Colors.black)),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}