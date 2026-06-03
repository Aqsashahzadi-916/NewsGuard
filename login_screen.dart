import 'dart:developer';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_guard/Continue_screen.dart';
import 'signup.dart';
import 'forget_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //  EMAIL LOGIN

  Future<void> _loginWithEmail() async {

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Email and password cannot be empty",
          ),
        ),
      );

      return;
    }

    try {

      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {

        log("Email Login Successful");
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists &&
            (userDoc.data()?['isDisabled'] ?? false)) {

          await FirebaseAuth.instance.signOut();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Your account has been disabled"),
            ),
          );

          return;
        }
        // Save user in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({

          'uid': user.uid,
          'email': user.email,
          'provider': 'email',
          'lastLogin': DateTime.now(),

        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login Successful"),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ContinueAsScreen(),
          ),
        );
      }

    } catch (e) {

      log("Email Login Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Login failed. Check credentials.",
          ),
        ),
      );
    }
  }

  // UI

  @override
  Widget build(BuildContext context) {

    final height =
        MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: Stack(
        children: [

          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/newspaper.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Blur
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),

            child: Container(
              color: Colors.black.withOpacity(0.15),
            ),
          ),

          // Login UI
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: ConstrainedBox(
                constraints:
                const BoxConstraints(
                  maxWidth: 400,
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,

                  children: [

                    SizedBox(
                      height: height * 0.06,
                    ),

                    const Text(
                      "We’re Glad to see you",

                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Email
                    TextField(
                      controller: _emailController,

                      style: const TextStyle(
                        color: Colors.white,
                      ),

                      decoration:
                      _inputDecoration(
                        "Email Address",
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Password
                    TextField(
                      controller:
                      _passwordController,

                      obscureText: _obscureText,

                      style: const TextStyle(
                        color: Colors.white,
                      ),

                      decoration:
                      _inputDecoration(
                        "Password",

                        suffix: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons
                                .visibility_off
                                : Icons
                                .visibility,

                            color: Colors.white,
                          ),

                          onPressed: () {

                            setState(() {
                              _obscureText =
                              !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Login Button
                    SizedBox(
                      height: 48,

                      child: ElevatedButton(
                        onPressed:
                        _loginWithEmail,

                        style:
                        ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          Colors.blue,

                          foregroundColor:
                          Colors.white,

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              30,
                            ),
                          ),
                        ),

                        child:
                        const Text("Login"),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Forgot Password
                    TextButton(
                      onPressed: () {

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                            const ForgotPasswordScreen(),
                          ),
                        );
                      },

                      child: const Text(
                        "Forgot the password?",

                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Signup
                    GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                            const SignupScreen(),
                          ),
                        );
                      },

                      child: const Center(
                        child: Text.rich(
                          TextSpan(
                            text:
                            "Don't have an account? ",

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),

                            children: [

                              TextSpan(
                                text: "Sign up",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight.bold,

                                  decoration:
                                  TextDecoration
                                      .underline,
                                ),
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
          ),
        ],
      ),
    );
  }

  //  INPUT DECORATION

  InputDecoration _inputDecoration(
      String hint, {
        Widget? suffix,
      }) {

    return InputDecoration(

      hintText: hint,

      hintStyle: const TextStyle(
        color: Colors.white70,
      ),

      filled: true,

      fillColor:
      Colors.white.withOpacity(0.15),

      suffixIcon: suffix,

      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(30),

        borderSide: BorderSide.none,
      ),
    );
  }
}
