import 'package:flutter/material.dart';
import 'onboarding_flow.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingFlow()),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("🔥", style: TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            const Text(
              "1 DAY STREAK",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Ready to personalize your kitchen?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingFlow()),
              ),
              child: const Text("Start p Setup"),
            ),
          ],
        ),
      ),
    );
  }
}
