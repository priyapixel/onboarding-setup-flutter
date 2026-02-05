class OnboardingData {
  String gender = '';
  DateTime? dob;
  double height = 0;
  double weight = 0;
  bool isMetric = true;
  String activityLevel = '';
  String mainActivity = '';
  String dietPlan = '';
  List<String> healthGoals = [];
  List<String> allergies = [];
  List<String> dislikedIngredients = [];
  String cuisine = '';
  List<String> preferredCuisines = [];
  List<String> additionalGoals = [];
  String maxCookingTime = "No limit"; // Default value
  String cookingType = "Full Kitchen"; // Default value
  String cookingFreq = "Daily (1)";
  String heavyMeal = '';
  List<String> vegDays = [];
  double budget = 2000.0;
  String cookingLevel = '';
  List<CookingDay> cookingDays = [
    CookingDay("Mon"),
    CookingDay("Tue"),
    CookingDay("Wed"),
    CookingDay("Thu"),
    CookingDay("Fri"),
    CookingDay("Sat"),
    CookingDay("Sun"),
  ];
}

class CookingDay {
  String day;
  String? type; // 'veg', 'non-veg', or null
  CookingDay(this.day, {this.type});
}
