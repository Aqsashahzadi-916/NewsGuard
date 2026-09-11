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

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    bool isValid = true;

    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    if (email.isEmpty) {
      _emailError = "Email is required";
      isValid = false;
    } else if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email)) {
      _emailError = "Enter a valid email address";
      isValid = false;
    }

    if (password.isEmpty) {
      _passwordError = "Password is required";
      isValid = false;
    }

    if (!isValid) {
      setState(() {});
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

          if (!mounted) return;

          return;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(
          {
            'uid': user.uid,
            'email': user.email,
            'provider': 'email',
            'lastLogin': DateTime.now(),
          },
          SetOptions(merge: true),
        );

        if (!mounted) return;

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
    } on FirebaseAuthException catch (e) {
      log("Firebase Login Error: ${e.code}");

      if (!mounted) return;

      if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        setState(() {
          _passwordError = "Invalid password";
        });
      }
    } catch (e) {
      log("Email Login Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/newspaper.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.15),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _emailController,
                      keyboardType:
                      TextInputType.emailAddress,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      onChanged: (value) {
                        if (_emailError != null) {
                          setState(() {
                            _emailError = null;
                          });
                        }
                      },
                      decoration: _inputDecoration(
                        "Email Address",
                        errorText: _emailError,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      onChanged: (value) {
                        if (_passwordError != null) {
                          setState(() {
                            _passwordError = null;
                          });
                        }
                      },
                      decoration: _inputDecoration(
                        "Password",
                        errorText: _passwordError,
                        suffix: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
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
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _loginWithEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text("Login"),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                                  TextDecoration.underline,
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

  InputDecoration _inputDecoration(
      String hint, {
        Widget? suffix,
        String? errorText,
      }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white70,
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.15),
      suffixIcon: suffix,
      errorText: errorText,
      errorStyle: const TextStyle(
        color: Colors.red,
        fontSize: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }
}
