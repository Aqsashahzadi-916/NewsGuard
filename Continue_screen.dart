import 'package:flutter/material.dart';
import 'package:news_guard/Home_screen.dart';
import 'package:news_guard/admin_dashboard.dart';

class ContinueAsScreen extends StatelessWidget {
  const ContinueAsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // Background Gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF005BFF),
              Color(0xFF12D8D8),
            ],
          ),
        ),

        child: Column(
          children: [

            // TOP AREA (LINES + LOGO)
            SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [

                  // Diagonal White Lines
                  Positioned(
                    top: 120,
                    left: -120,
                    right: -120,
                    child: Transform.rotate(
                      angle: 0.32,
                      child: Column(
                        children: [

                          // Line 1
                          Container(
                            width: 500,
                            height: 8,
                            color: Colors.white70,
                          ),

                          const SizedBox(height: 10),

                          // Line 2
                          Container(
                            width: 500,
                            height: 8,
                            color: Colors.white70,
                          ),

                          const SizedBox(height: 10),

                          // Line 3
                          Container(
                            width: 800,
                            height: 8,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Logo Between Lines
                  Positioned(
                    top: 60,
                    child: Image.asset(
                      'assets/logo.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            // Continue As Text
            const SizedBox(height: 30),

            const Padding(
              padding: EdgeInsets.only(right: 115),
              child: Text(
                'Continue as',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const SizedBox(height: 60),

            // USER BUTTON
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  HomeScreen(),
                  ),
                );
              },
              child: Container(
                width: 205,
                height: 40,
                color: const Color(0xFF001BB5),
                child: const Center(
                  child: Text(
                    'User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),

            // GUEST BUTTON
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminDashboardScreen(),
                  ),
                );
              },
              child: Container(
                width: 205,
                height: 40,
                color: const Color(0xFF001BB5),
                child: const Center(
                  child: Text(
                    'Guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


