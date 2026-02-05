import 'package:flutter/material.dart';

class MeasurementInput extends StatelessWidget {
  final bool isMetric;
  final Function(bool) onUnitChanged;
  final TextEditingController heightController;
  final TextEditingController weightController;

  const MeasurementInput({
    super.key,
    required this.isMetric,
    required this.onUnitChanged,
    required this.heightController,
    required this.weightController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Unit Toggle Switch
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Unit System", style: TextStyle(fontWeight: FontWeight.bold)),
            ToggleButtons(
              borderRadius: BorderRadius.circular(12),
              isSelected: [isMetric, !isMetric],
              onPressed: (index) => onUnitChanged(index == 0),
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Metric")),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Imperial")),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),
        
        // Height Input
        Text("Height (${isMetric ? 'cm' : 'ft/in'})", style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: heightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: isMetric ? "e.g. 175" : "e.g. 5.9",
            prefixIcon: const Icon(Icons.height),
          ),
        ),
        const SizedBox(height: 20),

        // Weight Input
        Text("Weight (${isMetric ? 'kg' : 'lbs'})", style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: weightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: isMetric ? "e.g. 70" : "e.g. 154",
            prefixIcon: const Icon(Icons.monitor_weight_outlined),
          ),
        ),
      ],
    );
  }
}