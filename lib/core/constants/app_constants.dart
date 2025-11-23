class AppConstants {
  // App Info
  static const String appName = 'Fit Buddy';
  static const String appVersion = '1.0.0';

  // ML Model Constants
  static const double poseDetectionConfidenceThreshold = 0.7;
  static const int maxPoseLandmarks = 33;

  // Camera Settings
  static const int defaultCameraFPS = 30;
  static const double defaultCameraAspectRatio = 16 / 9;

  // Workout Constants
  static const int defaultRestTime = 60; // seconds
  static const int defaultSetCount = 4;
  static const int defaultRepCount = 12;

  // API Configuration
  static const String grokApiBaseUrl = 'https://api.x.ai/v1';
  static const String grokModel = 'grok-beta';
  static const int apiTimeout = 30; // seconds

  // Storage Keys
  static const String apiKeyStorageKey = 'grok_api_key';
  static const String userPrefsKey = 'user_preferences';
  static const String workoutHistoryKey = 'workout_history';

  // Muscle Groups
  static const List<String> muscleGroups = [
    'chest',
    'back',
    'shoulders',
    'biceps',
    'triceps',
    'legs',
    'core',
    'glutes',
  ];

  // Exercise Categories
  static const List<String> exerciseCategories = [
    'Push',
    'Pull',
    'Legs',
    'Core',
    'Cardio',
  ];
}
