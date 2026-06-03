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


        decoration: const BoxDecoration(

             color:  Color(0xFFA0F9FF),
        ),

        child: Column(
          children: [
            SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [

                  Positioned(
                    top: 125,
                    child: Transform.rotate(
                      angle: 0.32,
                      child: Column(
                        children: [
                          Container(
                            width: 600,
                            height: 8,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 14),

                          Container(
                            width: 600,
                            height: 8,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 14),

                          Container(
                            width: 600,
                            height: 8,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),

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
                  color: Colors.blue,
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
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    'User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
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
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    'Guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            )
      ],
    ),
    ),
    );
  }
}
