import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int selectedTab = 0; // 0 = Users, 1 = Overview

  final List<String> users = [
    "User1@gmail.com",
    "User2@gmail.com",
    "User3@gmail.com",
    "User4@gmail.com",
    "User5@gmail.com",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF22D3CE),

      // 🔹 APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Admin panel",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                "NewsGuard management",
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () => _showAdminProfile(context),
          ),
        ],
      ),

      body: Column(
        children: [
          // 🔹 TABS
          Container(
            color: Colors.white,
            child: Row(
              children: [
                _tabItem("Users", 0),
                _tabItem("Overview", 1),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ================= USERS TAB =================
          if (selectedTab == 0) ...[
            const Text(
              "Logged-in users",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return _userCard(users[index]);
                },
              ),
            ),
          ],

          // ================= OVERVIEW TAB =================
          if (selectedTab == 1) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Here is the overview of entire system",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _overviewCard(
                    icon: Icons.people,
                    title: "2",
                    subtitle: "Total users",
                  ),
                  _overviewCard(
                    icon: Icons.article,
                    title: "12",
                    subtitle: "Total news submitted",
                  ),
                  _overviewCard(
                    icon: Icons.trending_up,
                    title: "85%",
                    subtitle: "High reliability",
                  ),

                  // 🔹 SENTIMENTS (same UI style)
                  _overviewCard(
                    icon: Icons.mood,
                    title: "Sentiments",
                    subtitle: "Positive 19 | Neutral 5 | Negative 2",
                    isBigText: false,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 🔹 TAB ITEM
  Widget _tabItem(String title, int index) {
    final bool isSelected = selectedTab == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.black : Colors.grey.shade300,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight:
                isSelected ? FontWeight.bold : FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 USER CARD
  Widget _userCard(String email) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(email, style: const TextStyle(fontSize: 15)),
          ),
          Tooltip(
            message: "Delete user",
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {},
            ),
          ),
          Tooltip(
            message: "Disable user",
            child: IconButton(
              icon: const Icon(Icons.block),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 OVERVIEW CARD (USED FOR ALL METRICS)
  Widget _overviewCard({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isBigText = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: isBigText ? 22 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 🔹 ADMIN PROFILE POPUP
  void _showAdminProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                "Admin Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                "admin@newsguard.com",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

