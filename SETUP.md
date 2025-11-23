# Fit Buddy - Setup Guide

## Prerequisites

Ensure you have the following installed:
- Flutter SDK 3.0.0 or higher
- Dart SDK
- For iOS: Xcode 14+ and CocoaPods
- For Android: Android Studio with SDK 21+

## Initial Setup

### 1. Clone and Initialize

```bash
git clone <your-repo-url>
cd RepRight
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run Code Generation

The project uses code generation for Riverpod, Freezed, and JSON serialization:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

For development, you can run the builder in watch mode:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 4. Configure Grok API Key

This app uses Grok AI for the fitness chat feature. You'll need an API key from X.AI:

1. Get your API key from [console.x.ai](https://console.x.ai/)
2. Create a `.env` file in the root directory (use `.env.example` as template)
3. Add your API key:
   ```
   GROK_API_KEY=your_actual_api_key_here
   ```

Alternatively, you can set the API key in the app settings on first launch.

## Platform-Specific Setup

### iOS Setup

1. **Update Info.plist** (`ios/Runner/Info.plist`)

Add the following permissions:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to analyze your workout form and posture in real-time</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is needed for voice coaching features</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Access to photo library to save workout videos</string>
```

2. **Update Podfile** (`ios/Podfile`)

Ensure minimum iOS version is 12.0:

```ruby
platform :ios, '12.0'
```

3. **Install Pods**

```bash
cd ios
pod install
cd ..
```

### Android Setup

1. **Update AndroidManifest.xml** (`android/app/src/main/AndroidManifest.xml`)

Add the following permissions before the `<application>` tag:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="28" />

<uses-feature android:name="android.hardware.camera" />
<uses-feature android:name="android.hardware.camera.autofocus" />
```

2. **Update build.gradle** (`android/app/build.gradle`)

Ensure minimum SDK version is 21:

```gradle
android {
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
    }
}
```

3. **Enable multidex** (if needed)

In `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        multiDexEnabled true
    }
}

dependencies {
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

## Running the App

### Development Mode

```bash
# Run on connected device/emulator
flutter run

# Run in debug mode with specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

### Release Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## Project Structure

```
lib/
├── core/
│   ├── config/         # App configuration (router, env)
│   ├── theme/          # Theme and styling
│   ├── constants/      # App constants
│   └── utils/          # Utility functions
├── features/
│   ├── workout/        # Workout scheduling & tracking
│   │   ├── data/       # Data layer (repositories, models)
│   │   ├── domain/     # Business logic
│   │   └── presentation/ # UI (screens, widgets)
│   ├── camera/         # Live pose detection & visualization
│   ├── chat/           # Grok AI chat
│   └── profile/        # User profile & settings
├── shared/
│   ├── models/         # Shared data models
│   ├── services/       # Shared services (API, ML)
│   └── widgets/        # Reusable widgets
└── main.dart           # App entry point
```

## Key Features Implementation

### 1. Pose Detection

The app uses **Google ML Kit Pose Detection** for real-time body tracking:

- Location: `lib/shared/services/pose_detection_service.dart`
- Provides 33 body landmarks
- Runs on-device for privacy
- Used in the camera/live workout screen

### 2. Grok AI Chat

Integration with Grok AI for fitness coaching:

- Service: `lib/shared/services/grok_service.dart`
- Model: `grok-beta` (can be updated to `grok-4-1-fast-reasoning`)
- Features conversation history
- Fitness-focused system prompt

To update to grok-4-1-fast-reasoning, modify `lib/shared/services/grok_service.dart`:

```dart
final response = await _dio.post(
  '/chat/completions',
  data: {
    'model': 'grok-4-1-fast-reasoning', // Update this line
    // ...
  },
);
```

### 3. Muscle Activation Visualization

- Location: `lib/shared/services/pose_detection_service.dart`
- Analyzes joint angles to estimate muscle engagement
- Currently supports basic squat analysis
- Extensible for other exercises

## Development Workflow

1. **Hot Reload**: Press `r` in the terminal while running to hot reload
2. **Hot Restart**: Press `R` to hot restart
3. **Code Generation**: Run build_runner when adding new models/providers
4. **Linting**: The project follows Flutter lints - check with `flutter analyze`

## Troubleshooting

### Code Generation Issues

If you get errors about missing `.g.dart` or `.freezed.dart` files:

```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Camera Not Working

- Ensure permissions are properly configured
- Check that you're running on a physical device (simulator cameras have limitations)
- Verify camera permissions are granted in device settings

### Grok API Errors

- Verify your API key is correct
- Check your internet connection
- Ensure your API key has proper permissions and isn't rate-limited
- Check the X.AI console for API status

### Build Errors

1. Clean the build:
   ```bash
   flutter clean
   flutter pub get
   ```

2. For iOS specifically:
   ```bash
   cd ios
   pod deintegrate
   pod install
   cd ..
   ```

## Next Steps

After setup, you can:

1. **Implement Real Camera**: Connect the camera screen to actual camera feed
2. **Add Workout Database**: Implement workout storage with Hive
3. **Enhance Pose Analysis**: Add more exercise-specific form analysis
4. **Improve Muscle Visualization**: Create AR overlay for muscle highlighting
5. **Add User Authentication**: Implement user accounts and cloud sync

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Google ML Kit](https://developers.google.com/ml-kit)
- [Riverpod Documentation](https://riverpod.dev/)
- [X.AI API Docs](https://docs.x.ai/)

## Support

For issues or questions:
- Check existing GitHub issues
- Create a new issue with details
- Include Flutter doctor output: `flutter doctor -v`
