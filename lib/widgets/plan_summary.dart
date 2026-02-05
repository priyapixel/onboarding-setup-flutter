import 'package:flutter/material.dart';
import '../models/onboarding_data.dart';

class PlanSummary extends StatefulWidget {
  final OnboardingData data;

  const PlanSummary({super.key, required this.data});

  @override
  State<PlanSummary> createState() => _PlanSummaryState();
}

class _PlanSummaryState extends State<PlanSummary> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    // We use a Container instead of Scaffold to avoid nested scaffold issues
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const Text("🎯", style: TextStyle(fontSize: 50)),
                  const SizedBox(height: 12),
                  const Text(
                    "Strategy Ready!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Tailored based on your profile",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Stats Tiles with Null Checks
            _buildInfoTile(
              icon: Icons.restaurant_menu_rounded,
              title: "Dietary Path",
              subtitle: "${widget.data.dietPlan ?? 'Custom'} lifestyle",
              color: Colors.red,
              trailing: widget.data.cookingLevel ?? 'Beginner',
            ),
            _buildInfoTile(
              icon: Icons.fitness_center_rounded,
              title: "Activity & Weight",
              subtitle:
                  "${widget.data.weight ?? '--'}kg · ${widget.data.activityLevel ?? 'Moderate'}",
              color: Colors.blue,
            ),
            _buildInfoTile(
              icon: Icons.account_balance_wallet_rounded,
              title: "Weekly Budget",
              subtitle: "₹${widget.data.budget?.round() ?? '0'} allocated",
              color: Colors.green,
            ),

            const SizedBox(height: 24),

            // Macro Card
            _buildMacroCard(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Macro Breakdown",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Icon(Icons.auto_awesome, size: 18, color: Colors.orange),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 20,
              child: Row(
                children: [
                  Expanded(flex: 4, child: Container(color: Colors.blue)),
                  Expanded(flex: 3, child: Container(color: Colors.green)),
                  Expanded(flex: 3, child: Container(color: Colors.orange)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "40% P",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                "30% C",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                "30% F",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    String? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
