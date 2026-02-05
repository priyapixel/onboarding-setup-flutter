import 'package:flutter/material.dart';

class DietPreferences extends StatelessWidget {
  final String selectedPlan;
  final List<String> selectedGoals;
  final Function(String) onPlanSelected;
  final Function(String) onGoalToggled;

  const DietPreferences({
    super.key,
    required this.selectedPlan,
    required this.selectedGoals,
    required this.onPlanSelected,
    required this.onGoalToggled,
  });

  @override
  Widget build(BuildContext context) {
    final plans = ["Balanced", "Keto", "Vegan", "Vegetarian", "High Protein"];
    final goals = [
      "Lose Weight",
      "Build Muscle",
      "Improve Immunity",
      "Better Sleep",
      "High Energy",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Diet Plan",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: plans.map((plan) {
            final isSelected = selectedPlan == plan;
            return ChoiceChip(
              label: Text(plan),
              selected: isSelected,
              onSelected: (_) => onPlanSelected(plan),
              selectedColor: Colors.blue.shade100,
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue.shade800 : Colors.black,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 30),
        const Text(
          "Health Goals",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text(
          "Select all that apply",
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 12),
        // Goal Selection
        ...goals.map((goal) {
          final isSelected = selectedGoals.contains(goal);
          return CheckboxListTile(
            title: Text(goal),
            value: isSelected,
            onChanged: (_) => onGoalToggled(goal),
            controlAffinity: ListTileControlAffinity.leading,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );
        }).toList(),
      ],
    );
  }
}
