import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_guard/admin_main.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends State<AdminDashboardScreen> {
  final TextEditingController _passwordController =
  TextEditingController();

  bool _obscurePassword = true;


  bool _passwordCorrect = false;

  // Admin password
  final String adminPassword = "1357";

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _checkPassword() {
    final enteredPassword =
    _passwordController.text.trim();

    if (enteredPassword == adminPassword) {
      // Password correct
      setState(() {
        _passwordCorrect = true;
      });


      Future.delayed(
        const Duration(seconds: 1),
            () {
          if (!mounted) return;


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminScreen(),
            ),
          );
        },
      );
    } else {
      // Wrong password
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Incorrect admin password"),
        ),
      );

      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA0F9FF),

      body: Stack(
        children: [


          Positioned.fill(
            child: Container(
              color: const Color(0xFFA0F9FF),

              child: Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [

                    // NewsGuard
                    Text(
                      'NewsGuard',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Admin Dashboard
                    Text(
                      'Admin Dashboard',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (!_passwordCorrect)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 6,
                  sigmaY: 6,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.25),
                ),
              ),
            ),


          if (!_passwordCorrect)
            Center(
              child: Container(
                width: 340,
                padding: const EdgeInsets.all(25),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(20),

                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 20,
                      spreadRadius: 2,
                      color: Colors.black26,
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // Admin Icon
                    const Icon(
                      Icons.admin_panel_settings,
                      size: 55,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 15),

                    // Title
                    Text(
                      "Admin Access",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Description
                    const Text(
                      "Enter admin password to continue",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 20),


                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,

                      onSubmitted: (_) {
                        _checkPassword();
                      },

                      decoration: InputDecoration(
                        hintText:
                        "Enter Admin Password",

                        prefixIcon: const Icon(
                          Icons.lock,
                        ),

                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),

                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                              !_obscurePassword;
                            });
                          },
                        ),

                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,

                      child: ElevatedButton(
                        onPressed: _checkPassword,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),

                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
