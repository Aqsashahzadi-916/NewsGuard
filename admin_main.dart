import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_guard/login_screen.dart';
import 'login_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int selectedTab = 0; // 0 = Users, 1 = Overview

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
          //  TABS
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

          //  USERS TAB
        if (selectedTab == 0) ...[
    const Text(
    "Logged-in users",
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 16),
    Expanded(
    child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('users')
        .snapshots(),
    builder: (context, snapshot) {

    if (snapshot.connectionState ==
    ConnectionState.waiting) {
    return const Center(
    child: CircularProgressIndicator(),
    );
    }

    if (!snapshot.hasData ||
    snapshot.data!.docs.isEmpty) {
    return const Center(
    child: Text("No Users Found"),
    );
    }

    final users = snapshot.data!.docs;

    return ListView.builder(
    padding: const EdgeInsets.symmetric(
    horizontal: 16,
    ),
    itemCount: users.length,
    itemBuilder: (context, index) {

    final user =
    users[index].data() as Map<String, dynamic>;

    return _userCard(
    users[index].id,
    user['email'] ?? "No Email",
    user['isDisabled'] ?? false,
    );
    },
    );
    },
    ),
    ),
    ],
          //  OVERVIEW TAB
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

                  //  SENTIMENTS
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

  //  TAB ITEM
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
  Widget _userCard(
      String uid,
      String email,
      bool isDisabled,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),

                Text(
                  isDisabled
                      ? "Disabled"
                      : "Active",
                  style: TextStyle(
                    color: isDisabled
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // Delete User
          IconButton(
            tooltip: "delete",
            color: Colors.black,
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .delete();
            },
          ),

          // Disable User
          IconButton(
            tooltip: "Disable",
            color: Colors.black,
            icon: Icon(
              isDisabled
                  ? Icons.check_circle
                  : Icons.block,
            ),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .update({
                'isDisabled': !isDisabled,
              });
            },
          ),
        ],
      ),
    );
  }

  // OVERVIEW
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

  //  ADMIN PROFILE
  void _showAdminProfile(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
              Text(
                user?.email ?? "No Email",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                        (route) => false,
                  );
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
