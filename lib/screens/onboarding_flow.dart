import 'package:flutter/material.dart';
import '../models/onboarding_data.dart';
import '../widgets/plan_summary.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentStep = 1;
  final OnboardingData _data = OnboardingData();
  final TextEditingController _dobController = TextEditingController();

  // Brand Color: rgb(179, 32, 36)
  final Color brandRed = const Color.fromARGB(255, 179, 32, 36);

  void _next() {
    FocusScope.of(context).unfocus();
    setState(() {
      if (_currentStep < 12) {
        _currentStep++;
      } else {
        // Final Action
        Navigator.pop(context);
      }
    });
  }

  void _prev() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _formatDOB(String value) {
    String text = value.replaceAll('/', '');
    if (text.length > 8) text = text.substring(0, 8);
    String newText = '';
    for (int i = 0; i < text.length; i++) {
      newText += text[i];
      if ((i == 1 || i == 3) && i != text.length - 1) newText += '/';
    }
    _dobController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 40, // Reduced width to keep the title close to the icon
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: brandRed, size: 20),
          onPressed: _prev,
        ),
        title: const Text(
          "Health Profile Setup",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Step $_currentStep of 12",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${((_currentStep / 12) * 100).round()}%",
                      style: TextStyle(
                        color: brandRed,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              LinearProgressIndicator(
                value: _currentStep / 12,
                backgroundColor: brandRed.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(brandRed),
                minHeight: 3, // Slightly thinner for a sleek look
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: _renderStep(),
        ),
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  Widget _renderStep() {
    switch (_currentStep) {
      case 1:
        return _buildGenderStep();
      case 2:
        return _buildDOBStep();
      case 3:
        return _buildMeasurementStep();
      case 4:
        return _buildPrimaryGoalStep();
      case 5:
        return _buildTargetWeightStep();
      case 6:
        return _buildWeightLossSpeedStep();
      case 7:
        return _buildActivityStep();
      case 8:
        return _buildDietGoalStep();
      case 9:
        return _buildAllergiesStep();
      case 10:
        return _buildKitchenStep();
      case 11:
        return _buildCookingLevelStep();
      case 12:
        return PlanSummary(data: _data);
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }

  // --- STEP 1: GENDER ---
  Widget _buildGenderStep() {
    return _selectionList("What is your gender?", [
      {"label": "Male", "icon": Icons.male},
      {"label": "Female", "icon": Icons.female},
      {"label": "Other", "icon": Icons.more_horiz},
    ], (val) => _data.gender = val);
  }

  // --- STEP 2: DOB ---
  Widget _buildDOBStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "When were you born?",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 40),
        _buildTextFieldContainer(
          TextField(
            controller: _dobController,
            autofocus: true,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "DD / MM / YYYY",
              border: InputBorder.none,
              prefixIcon: Icon(Icons.cake, color: brandRed),
            ),
            onChanged: _formatDOB,
          ),
        ),
      ],
    );
  }

  // --- STEP 3: MEASUREMENTS ---
  Widget _buildMeasurementStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Current measurements",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 20),
        _buildUnitToggle(),
        const SizedBox(height: 30),
        _buildManualInputCard(
          "Height",
          _data.isMetric ? "cm" : "in",
          Icons.height,
          (val) => setState(() => _data.height = double.tryParse(val) ?? 0),
        ),
        const SizedBox(height: 16),
        _buildManualInputCard(
          "Weight",
          _data.isMetric ? "kg" : "lb",
          Icons.monitor_weight_outlined,
          (val) => setState(() => _data.weight = double.tryParse(val) ?? 0),
        ),
      ],
    );
  }

  // --- STEP 4, 5, 6: GOALS ---
  Widget _buildPrimaryGoalStep() {
    return _selectionListWithIcons("Primary Goal", [
      {"label": "Lose Weight", "icon": Icons.monitor_weight},
      {"label": "Maintain Weight", "icon": Icons.scale},
      {"label": "Gain Muscle", "icon": Icons.fitness_center},
      {"label": "Increase Energy", "icon": Icons.bolt},
    ], (val) => _data.dietPlan = val);
  }

  Widget _selectionListWithIcons(
    String title,
    List<Map<String, dynamic>> items,
    Function(String) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 30),
        ...items.map((item) {
          bool isSelected = _data.dietPlan == item['label'];
          return GestureDetector(
            onTap: () {
              setState(() => onSelect(item['label']));
              Future.delayed(const Duration(milliseconds: 200), _next);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected ? brandRed : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? brandRed : Colors.grey.shade200,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: brandRed.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Icon(
                    item['icon'],
                    color: isSelected ? Colors.white : brandRed,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    item['label'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected ? Colors.white : Colors.grey.shade300,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTargetWeightStep() {
    double currentWeight = _data.weight;
    double targetWeight = _data.budget;
    String unit = _data.isMetric ? "kg" : "lb";

    // FIX: Only treat the target as "entered" if it's in a realistic range.
    // This prevents the '2026' or '0' values from triggering the calculation.
    bool isTargetEntered = targetWeight > 20 && targetWeight < 500;

    double diff = isTargetEntered ? (targetWeight - currentWeight) : 0;
    bool isLoss = diff < 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What is your target weight?",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),

        // Current weight chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "Current: $currentWeight $unit",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 30),

        _buildManualInputCard("Target Weight", unit, Icons.track_changes, (
          val,
        ) {
          setState(() {
            // Safely parse the input
            _data.budget = double.tryParse(val) ?? 0;
          });
        }),

        // Only show the result if a valid target was actually typed
        if (isTargetEntered && diff.abs() > 0.1) ...[
          const SizedBox(height: 24),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: brandRed.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: brandRed.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isLoss ? Icons.trending_down : Icons.trending_up,
                  color: brandRed,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    "You aim to ${isLoss ? 'lose' : 'gain'} ${diff.abs().toStringAsFixed(1)} $unit",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: brandRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _selectionListWithSubtext(
    String title,
    List<Map<String, dynamic>> items,
    String currentSelection,
    Function(String) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          "Choose a pace that fits your lifestyle.",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
        const SizedBox(height: 30),
        ...items.map((item) {
          bool isSelected = _data.mainActivity == item['label'];
          return GestureDetector(
            onTap: () {
              setState(() => onSelect(item['label']));
              Future.delayed(const Duration(milliseconds: 200), _next);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? brandRed : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? brandRed : Colors.grey.shade200,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: isSelected ? Colors.white : brandRed,
                    size: 28,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['label'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['subtext'],
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected
                                ? Colors.white.withOpacity(0.9)
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: isSelected ? Colors.white : Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildWeightLossSpeedStep() {
    double diff = (_data.budget - _data.weight);
    bool isGain = diff > 0;
    String goalAction = isGain ? "Gain" : "Loss";
    String unit = _data.isMetric ? "kg" : "lb";

    return _selectionListWithSubtext(
      "Transformation Pace",
      [
        {
          "label": "Steady",
          "subtext": "0.25 $unit / week - Focus on long-term habits.",
          "icon": Icons.speed, // Changed from BakeryDiningOutlined
        },
        {
          "label": "Balanced",
          "subtext": "0.5 $unit / week - A healthy rate for $goalAction.",
          "icon": Icons.balance,
        },
        {
          "label": "Aggressive",
          "subtext": "1.0 $unit / week - Fast results, high discipline.",
          "icon": Icons.rocket_launch, // Changed from rocket_launch_outlined
        },
      ],
      _data.activityLevel,
      (val) => _data.mainActivity = val,
    );
  }

  // --- STEP 7-11: LIFESTYLE ---
  Widget _buildActivityStep() {
    return _selectionListWithSubtext(
      "Activity Level",
      [
        {
          "label": "Sedentary",
          "subtext":
              "Little to no exercise. Mostly sitting (e.g., Office Job).",
          "icon": Icons.chair_alt,
        },
        {
          "label": "Lightly Active",
          "subtext": "Light exercise or sports 1-3 days/week.",
          "icon": Icons.directions_walk,
        },
        {
          "label": "Moderately Active",
          "subtext": "Moderate exercise or sports 3-5 days/week.",
          "icon": Icons.fitness_center,
        },
        {
          "label": "Very Active",
          "subtext": "Hard exercise or intense sports 6-7 days/week.",
          "icon": Icons.run_circle,
        },
      ],
      _data.activityLevel,
      (val) => setState(() => _data.activityLevel = val),
    );
  }

  Widget _buildDietGoalStep() {
    final List<Map<String, dynamic>> dietOptions = [
      {'label': 'Vegetarian', 'icon': '🥦', 'sub': 'Plant-based'},
      {'label': 'Non-Veg', 'icon': '🍗', 'sub': 'Meats & more'},
      {'label': 'Vegan', 'icon': '🌱', 'sub': 'Strictly plants'},
      {'label': 'Pescatarian', 'icon': '🐟', 'sub': 'Fish & Veg'},
      {'label': 'Eggatarian', 'icon': '🥚', 'sub': 'Eggs & Veg'},
      {'label': 'Halal', 'icon': '🌙', 'sub': 'Certified'},
      {'label': 'Kosher', 'icon': '✡️', 'sub': 'Special prep'},
      {'label': 'Jain', 'icon': '🕉️', 'sub': 'No roots'},
      {'label': 'High Protein', 'icon': '🥩', 'sub': 'Muscle'},
      {'label': 'Keto', 'icon': '🥑', 'sub': 'Low carb'},
      {'label': 'Diabetic', 'icon': '🩺', 'sub': 'Low sugar'},
      {'label': 'Gluten-free', 'icon': '🌾', 'sub': 'No wheat'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Dietary Preference",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          "Select your lifestyle plan.",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 20),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemCount: dietOptions.length,
          itemBuilder: (context, index) {
            final item = dietOptions[index];
            bool isSelected = _data.dietPlan == item['label'];

            return GestureDetector(
              onTap: () {
                // Now only updates the state, does NOT call _next()
                setState(() => _data.dietPlan = item['label']);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? brandRed : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? brandRed : Colors.grey.shade200,
                    width: 1.5,
                  ),
                  // Added a subtle shadow when selected
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: brandRed.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item['icon'], style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 6),
                    Text(
                      item['label'],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['sub'],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 9,
                        color: isSelected
                            ? Colors.white.withOpacity(0.8)
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),
        _buildSectionTitle("Health Goals"),
        _buildHealthGoalsGrid(),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _selectionListWithEmoji(
    String title,
    List<Map<String, dynamic>> items,
    String currentSelection,
    Function(String) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 20),
        ...items.map((item) {
          bool isSelected = currentSelection == item['label'];

          return GestureDetector(
            onTap: () {
              setState(() => onSelect(item['label']));
              Future.delayed(const Duration(milliseconds: 200), _next);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? brandRed : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? brandRed : Colors.grey.shade200,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  // Emoji display
                  Text(item['icon'], style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['label'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          item['sub'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  // Add these controllers to your State class to handle the "Custom" inputs
  final TextEditingController _allergyController = TextEditingController();
  final TextEditingController _dislikeController = TextEditingController();

  Widget _buildAllergiesStep() {
    final allergyOptions = [
      'Peanuts',
      'Tree Nuts',
      'Dairy',
      'Eggs',
      'Soy',
      'Wheat',
      'Shellfish',
      'Fish',
    ];
    final ingredientOptions = [
      'Mushrooms',
      'Olives',
      'Cilantro',
      'Onion',
      'Tomatoes',
      'Eggplant',
      'Bell Peppers',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Safety & Taste 🚫",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          "We'll exclude these from your recommendations.",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 30),

        // --- ALLERGIES SECTION ---
        _buildMultiSelectSection(
          label: "STRICT ALLERGIES 🚨",
          options: allergyOptions,
          selectedItems: _data.allergies, // Assumes this is a List<String>
          activeColor: const Color(0xFFFF6B6B),
          controller: _allergyController,
          onToggle: (item) => setState(() {
            _data.allergies.contains(item)
                ? _data.allergies.remove(item)
                : _data.allergies.add(item);
          }),
        ),

        const SizedBox(height: 32),

        // --- DISLIKES SECTION ---
        _buildMultiSelectSection(
          label: "INGREDIENTS YOU DISLIKE 🤢",
          options: ingredientOptions,
          selectedItems:
              _data.dislikedIngredients, // Ensure this exists in your model
          activeColor: const Color(0xFFFAB005),
          controller: _dislikeController,
          onToggle: (item) => setState(() {
            _data.dislikedIngredients.contains(item)
                ? _data.dislikedIngredients.remove(item)
                : _data.dislikedIngredients.add(item);
          }),
        ),
      ],
    );
  }

  Widget _buildMultiSelectSection({
    required String label,
    required List<String> options,
    required List<String> selectedItems,
    required Color activeColor,
    required TextEditingController controller,
    required Function(String) onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            bool isActive = selectedItems.contains(opt);
            return GestureDetector(
              onTap: () => onToggle(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive ? activeColor : Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: isActive ? activeColor : Colors.grey.shade200,
                    width: 1.5,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: activeColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  "$opt ${isActive ? '✕' : '+'}",
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Add other...",
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  onToggle(controller.text.trim());
                  controller.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0070F3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text("Add"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKitchenStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Tailor Your Kitchen 🥗",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
          ),
        ),

        const SizedBox(height: 28),

        // 1. Cuisines
        _buildSectionTitle("Preferred Cuisines"),
        _buildCuisineChips(),

        const SizedBox(height: 28),

        // 3. Selection Grids
        _buildSelectionGrid(
          "Cooking Time",
          [
            {'label': '15-30 mins', 'icon': '⏱️'},
            {'label': '45-60 mins', 'icon': '🍲'},
            {'label': 'No limit', 'icon': '👨‍🍳'},
          ],
          _data.maxCookingTime,
          (v) => setState(() => _data.maxCookingTime = v), // Added setState
        ),

        const SizedBox(height: 28),

        _buildSelectionGrid(
          "How often do you like to cook?",
          [
            {'label': 'Daily (3)', 'icon': '🔄'},
            {'label': 'Daily (1)', 'icon': '📅'},
            {'label': '5x Week', 'icon': '🖐️'},
            {'label': '3x Week', 'icon': '🕒'},
            {'label': '2x Week', 'icon': '✌️'},
            {'label': '1x Week', 'icon': '☝️'},
          ],
          _data.cookingFreq,
          (v) => setState(() => _data.cookingFreq = v),
        ),

        const SizedBox(height: 28),

        _buildSelectionGrid(
          "Kitchen Setup",
          [
            {'label': 'Air Fryer', 'icon': '🌬️'},
            {'label': 'Rice Cooker', 'icon': '🍚'},
            {'label': 'Full Kitchen', 'icon': '🍳'},
          ],
          _data.cookingType,
          (v) => setState(() => _data.cookingType = v),
        ),

        const SizedBox(height: 28),

        _buildCookingSchedule(),

        const SizedBox(height: 28),

        // 4. Budget Section (Cleaned up duplicates)
        _buildSectionTitle("Weekly Budget"),
        _buildBudgetInputGroup(), // New combined method below

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildBudgetInputGroup() {
    // 1. Calculate the numeric frequency from the label (e.g., "Daily (3)" -> 21 meals/week)
    int mealsPerWeek = _getMealCount(_data.cookingFreq);

    // 2. Calculate cost per meal (Budget / Frequency)
    double costPerMeal = mealsPerWeek > 0 ? (_data.budget / mealsPerWeek) : 0;

    final TextEditingController _controller = TextEditingController(
      text: _data.budget.toStringAsFixed(0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Slider(
                value: _data.budget,
                min: 0,
                max: 10000, // Increased max for Rupee context
                divisions: 100,
                activeColor: Colors.green,
                onChanged: (double value) {
                  setState(() {
                    _data.budget = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 1,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: '₹ ', // Changed to Rupee
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                onSubmitted: (String value) {
                  double? newValue = double.tryParse(value);
                  if (newValue != null) {
                    setState(() {
                      _data.budget = newValue.clamp(0, 10000);
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 3. Display the estimated cost per meal
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Estimated cost per meal:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "₹${costPerMeal.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper to turn your labels into numbers for calculation
  int _getMealCount(String freq) {
    if (freq.contains('Daily (3)')) return 21;
    if (freq.contains('Daily (1)')) return 7;
    if (freq.contains('5x Week')) return 5;
    if (freq.contains('3x Week')) return 3;
    if (freq.contains('2x Week')) return 2;
    if (freq.contains('1x Week')) return 1;
    return 1; // Default floor
  }

  // Small helper for consistent titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildCuisineChips() {
    final cuisines = {
      'Indian': {'flag': '🇮🇳', 'color': Color(0xFFFF9933)},
      'Italian': {'flag': '🇮🇹', 'color': Color(0xFF008C45)},
      'Mexican': {'flag': '🇲🇽', 'color': Color(0xFF006847)},
      'Chinese': {'flag': '🇨🇳', 'color': Color(0xFFEE1C25)},
      'Japanese': {'flag': '🇯🇵', 'color': Color(0xFFBC002D)},
      'Thai': {'flag': '🇹🇭', 'color': Color(0xFF2D2A4A)},
      'Korean': {'flag': '🇰🇷', 'color': Color(0xFF0047A0)},
      'Mediterranean': {'flag': '🇬🇷', 'color': Color(0xFF005BAE)},
      'American': {'flag': '🇺🇸', 'color': Color(0xFFB22234)},
      'French': {'flag': '🇫🇷', 'color': Color(0xFFED2939)},
    };

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: cuisines.entries.map((e) {
        bool active = _data.preferredCuisines.contains(e.key);
        return GestureDetector(
          onTap: () => setState(() {
            active
                ? _data.preferredCuisines.remove(e.key)
                : _data.preferredCuisines.add(e.key);
          }),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: active ? e.value['color'] as Color : Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: active
                    ? e.value['color'] as Color
                    : Colors.grey.shade200,
              ),
            ),
            child: Text(
              "${e.value['flag']} ${e.key}",
              style: TextStyle(
                color: active ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHealthGoalsGrid() {
    // 1. Define the data locally
    final List<Map<String, String>> healthGoals = [
      {'label': 'Muscle Gain', 'icon': '💪'},
      {'label': 'Heart Health', 'icon': '❤️'},
      {'label': 'Brain Health', 'icon': '🧠'},
      {'label': 'Hair Fall', 'icon': '💇'},
      {'label': 'Sugar Control', 'icon': '🩸'},
      {'label': 'Bone Health', 'icon': '🦴'},
      {'label': 'Eye Health', 'icon': '👁️'},
      {'label': 'Immunity', 'icon': '🛡️'},
      {'label': 'Better Sleep', 'icon': '😴'},
      {'label': 'Skin Health', 'icon': '✨'},
      {'label': 'Energy Boost', 'icon': '⚡'},
      {'label': 'Stress Relief', 'icon': '🧘'},
    ];

    return GridView.builder(
      shrinkWrap: true, // Crucial for use inside a Column/ListView
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columns
        crossAxisSpacing: 8, // Gap between items
        mainAxisSpacing: 8,
        childAspectRatio: 1.3, // Shape of the card
      ),
      itemCount: healthGoals.length,
      itemBuilder: (context, index) {
        final goal = healthGoals[index];
        // 2. Check if this goal is already in the list
        bool active = _data.additionalGoals.contains(goal['label']);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (active) {
                _data.additionalGoals.remove(goal['label']);
              } else {
                _data.additionalGoals.add(goal['label']!);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              // Use the specific React color #20c997 (mint green)
              color: active
                  ? const Color(0xFF20c997).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: active ? const Color(0xFF20c997) : Colors.grey.shade200,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(goal['icon']!, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Text(
                  goal['label']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: active ? const Color(0xFF20c997) : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCookingSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
      children: [
        const Text(
          "Food Preference",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          "Tap days to toggle Veg or Non-Veg meals.",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        const SizedBox(height: 16), // Gap between text and the day selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _data.cookingDays.map((dayObj) {
            bool isVeg = dayObj.type == 'veg';
            bool isNonVeg = dayObj.type == 'non-veg';

            Color borderColor = isNonVeg
                ? const Color(0xFFFD7E14)
                : (isVeg ? const Color(0xFF40C057) : Colors.grey.shade200);
            Color bgColor = isNonVeg
                ? const Color(0xFFFFF4E6)
                : (isVeg ? const Color(0xFFEBFBEE) : Colors.white);

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    // Cycle logic: null -> veg -> non-veg -> null
                    if (dayObj.type == null)
                      dayObj.type = 'veg';
                    else if (dayObj.type == 'veg')
                      dayObj.type = 'non-veg';
                    else
                      dayObj.type = null;
                  });
                },
                child: AnimatedContainer(
                  // Switched to AnimatedContainer for smoother color transitions
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        dayObj.day,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isNonVeg ? '🍗' : (isVeg ? '🥗' : '+'),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBudgetCalculator() {
    int getMealsPerWeek() {
      switch (_data.cookingFreq) {
        case 'Daily (3)':
          return 21;
        case 'Daily (1)':
          return 7;
        case '5x Week':
          return 5; // Added this
        case '3x Week':
          return 3;
        case '2x Week':
          return 2; // Added this
        case '1x Week':
          return 1; // Added this
        default:
          return 7;
      }
    }

    int meals = getMealsPerWeek();
    // Safety check to prevent dividing by zero
    int perMealAvg = meals > 0 ? (_data.budget / meals).round() : 0;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TOTAL BUDGET",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "₹${_data.budget.round()}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0070f3),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "PER MEAL AVG",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "₹$perMealAvg",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF20c997),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Slider(
          value: _data.budget.clamp(500.0, 20000.0), // Clamped to prevent crash
          min: 500.0,
          max: 20000.0,
          divisions: 39,
          activeColor: const Color(0xFF0070f3),
          onChanged: (v) => setState(() => _data.budget = v),
        ),
      ],
    );
  }

  Widget _buildSelectionGrid(
    String title,
    List<Map<String, String>> items,
    String current,
    Function(String) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.3,
          children: items.map((item) {
            bool active = current == item['label'];
            return GestureDetector(
              onTap: () => setState(() => onSelect(item['label']!)),
              child: Container(
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFF0070f3).withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: active
                        ? const Color(0xFF0070f3)
                        : Colors.grey.shade200,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item['icon']!, style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 4),
                    Text(
                      item['label']!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCookingLevelStep() {
    final List<Map<String, dynamic>> chefPersonas = [
      {
        'id': 'No Cooking',
        'title': 'Me No Cooking',
        'desc':
            'Microwaves and takeout are my best friends. Keep it zero-effort.',
        'icon': '🥡',
        'color': const Color(0xFFFF4757),
      },
      {
        'id': 'Noodles',
        'title': 'Me Makes Noodles',
        'desc':
            'I can boil water and follow basic box instructions. Simple wins.',
        'icon': '🍜',
        'color': const Color(0xFFFFA502),
      },
      {
        'id': 'Edible Elements',
        'title': 'Me Cooks Edible Elements',
        'desc':
            'I can sear a chicken breast and roast veggies without a fire alarm.',
        'icon': '🍳',
        'color': const Color(0xFF2ED573),
      },
      {
        'id': 'Gordon Ramsay',
        'title': 'Me Gordon Ramsay',
        'desc':
            'Reducing sauces, perfect plating, and shouting at undercooked proteins.',
        'icon': '👨‍🍳',
        'color': const Color(0xFF1E90FF),
      },
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
              children: [
                TextSpan(text: "What's your "),
                TextSpan(
                  text: "Kitchen Persona?",
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We'll adjust recipe complexity based on how much you (honestly) like to cook.",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 25),

          // Grid/List of options
          ...chefPersonas.map((persona) {
            bool isActive = _data.cookingLevel == persona['id'];
            Color themeColor = persona['color'];

            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: GestureDetector(
                onTap: () => setState(() => _data.cookingLevel = persona['id']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isActive
                        ? themeColor.withOpacity(0.05)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isActive ? themeColor : Colors.grey.shade200,
                      width: 2,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: themeColor.withOpacity(0.15),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    children: [
                      // Icon Container
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isActive ? themeColor : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          persona['icon'],
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(width: 15),

                      // Text Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              persona['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              persona['desc'],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Radio-style Check Indicator
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive ? themeColor : Colors.transparent,
                          border: Border.all(
                            color: isActive ? themeColor : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: isActive
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),

          // Pro Tip Box
          Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFCFCFC),
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "💡 Pro Tip: Even Gordon Ramsays appreciate a \"No Cooking\" day occasionally.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _selectionList(
    String title,
    List<Map<String, dynamic>> items,
    Function(String) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 30),
        ...items.map((item) {
          bool isSelected = _data.gender == item['label'];
          return GestureDetector(
            onTap: () {
              setState(() => onSelect(item['label']));
              Future.delayed(const Duration(milliseconds: 200), _next);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected ? brandRed : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? brandRed : Colors.grey.shade200,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    item['icon'],
                    color: isSelected ? Colors.white : brandRed,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    item['label'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _simpleList(
    String title,
    List<String> items,
    Function(String) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ...items.map(
          (i) => Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              title: Text(
                i,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: Icon(Icons.chevron_right, color: brandRed),
              onTap: () {
                onSelect(i);
                _next();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnitToggle() {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _toggleItem("Metric (kg/cm)", _data.isMetric),
          _toggleItem("Imperial (lb/in)", !_data.isMetric),
        ],
      ),
    );
  }

  Widget _toggleItem(String label, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _data.isMetric = label.contains("Metric")),
        child: Container(
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: active ? brandRed : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildManualInputCard(
    String label,
    String hint,
    IconData icon,
    Function(String) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: brandRed.withOpacity(0.1),
            child: Icon(icon, color: brandRed),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "0.0",
                    suffixText: hint,
                    border: InputBorder.none,
                  ),
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _dropdown(
    String label,
    List<String> opts,
    Function(String?) onChange,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      items: opts
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChange,
    );
  }

  Widget _buildBottomAction() {
    bool isLastStep = _currentStep == 12;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Important: prevents column from taking full screen height
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandRed,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: _next,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLastStep ? "View My Plan" : "Next",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!isLastStep) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8), // Gap between button and link
            TextButton(
              onPressed: () {
                // Navigates back to the very first screen in the stack
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              child: Text(
                "Back to Home Screen",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration:
                      TextDecoration.underline, // Makes it look like a link
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
