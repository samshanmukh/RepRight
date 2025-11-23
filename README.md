# Fit Buddy

An AI-powered fitness app with real-time posture correction and muscle activation visualization.

## Features

- 📅 **Scheduled Workouts**: Follow pre-planned gym sessions
- 🎯 **Real-time Posture Correction**: AI-powered form analysis during exercises
- 💪 **Muscle Activation Visualization**: Live muscle highlighting showing which muscles are engaged
- 🤖 **AI Chat**: Integrated Grok AI chat for fitness advice and questions

## Tech Stack

- **Framework**: Flutter (mobile-first, cross-platform)
- **State Management**: Riverpod
- **ML/AI**:
  - Google ML Kit (Pose Detection)
  - Grok API (grok-4-1-fast-reasoning for chat)
- **Camera**: Flutter Camera plugin
- **Architecture**: Feature-based clean architecture

## Project Structure

```
lib/
├── core/              # App-wide configuration, themes, constants
├── features/          # Feature modules
│   ├── workout/       # Workout scheduling & tracking
│   ├── camera/        # Live pose detection & muscle visualization
│   ├── chat/          # Grok AI chat integration
│   └── profile/       # User profile & settings
├── shared/            # Shared widgets, utilities, models
└── main.dart          # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- iOS: Xcode, CocoaPods
- Android: Android Studio, Android SDK

### Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd RepRight
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Configure API keys:
   - Create a `.env` file in the root directory
   - Add your Grok API key: `GROK_API_KEY=your_key_here`

5. Run the app:
```bash
flutter run
```

## Development

### Running code generation in watch mode:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Running tests:
```bash
flutter test
```

## Platform Requirements

### iOS
- Minimum iOS version: 12.0
- Camera and microphone permissions required

### Android
- Minimum SDK: 21 (Android 5.0)
- Camera permissions required

## License

See LICENSE file for details.
