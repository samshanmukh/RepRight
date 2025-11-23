# Fit Buddy - Architecture Documentation

## Overview

Fit Buddy follows a **feature-based clean architecture** approach with **Riverpod** for state management. This document outlines the architectural decisions and patterns used throughout the application.

## Architecture Principles

### 1. Feature-Based Structure

Each major feature is self-contained in its own directory:

```
features/
├── workout/
├── camera/
├── chat/
└── profile/
```

### 2. Layer Separation

Each feature follows a three-layer architecture:

- **Presentation Layer**: UI components (screens, widgets)
- **Domain Layer**: Business logic and use cases
- **Data Layer**: Data sources, repositories, models

```
feature/
├── presentation/    # UI layer
│   ├── screens/
│   ├── widgets/
│   └── controllers/
├── domain/          # Business logic
│   ├── entities/
│   └── usecases/
└── data/            # Data layer
    ├── models/
    ├── repositories/
    └── datasources/
```

## State Management

### Riverpod

We use **Riverpod** for state management because:

- Type-safe and compile-time checked
- Excellent for dependency injection
- Supports multiple provider types (Provider, StateProvider, FutureProvider, etc.)
- Great for testing
- Handles async operations elegantly

### Provider Types Used

1. **Provider**: For immutable dependencies (services, repositories)
   ```dart
   final grokServiceProvider = Provider<GrokService>((ref) {
     return GrokService(apiKey: apiKey);
   });
   ```

2. **StateNotifierProvider**: For mutable state
   ```dart
   final chatControllerProvider =
       StateNotifierProvider<ChatController, List<ChatMessage>>((ref) {
     return ChatController(ref.watch(chatRepositoryProvider));
   });
   ```

3. **FutureProvider**: For async data
   ```dart
   final grokApiKeyProvider = FutureProvider<String?>((ref) async {
     return await EnvConfig.getGrokApiKey();
   });
   ```

## Core Systems

### Navigation (GoRouter)

We use **go_router** for declarative routing:

- Type-safe navigation
- Deep linking support
- Easy nested navigation
- Shell routes for persistent bottom navigation

```dart
GoRouter(
  initialLocation: '/workout',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [...],
    ),
  ],
);
```

### Theme System

Centralized theming with support for light/dark modes:

- **AppTheme**: Defines Material 3 themes
- **AppColors**: Centralized color palette
- Muscle-specific colors for visualization

### Code Generation

The project uses code generation for:

1. **Freezed**: Immutable data classes with copyWith, equality
2. **json_serializable**: JSON serialization/deserialization
3. **Riverpod Generator**: Type-safe providers (optional, can be added)

Run code generation:
```bash
flutter pub run build_runner watch
```

## Feature Implementations

### 1. Workout Feature

**Purpose**: Manage workout scheduling and tracking

**Components**:
- `WorkoutScreen`: Displays scheduled workouts
- Workout models: Exercise, Set, Workout
- Workout repository: CRUD operations

**Future Enhancements**:
- Workout builder
- Exercise library
- Progress tracking
- Workout history with Hive

### 2. Camera/Pose Detection Feature

**Purpose**: Real-time pose detection and form analysis

**Tech Stack**:
- **Google ML Kit Pose Detection**: Body landmark detection
- **Camera Plugin**: Video stream access
- Custom analysis: Muscle activation estimation

**Data Flow**:
```
Camera Image → ML Kit → Pose Landmarks →
Angle Calculation → Muscle Activation → UI Update
```

**Key Services**:
- `PoseDetectionService`: Handles ML Kit integration
- Muscle activation algorithms: Joint angle analysis

**Performance Considerations**:
- Stream mode for real-time detection
- Throttle frame processing (30 FPS)
- On-device processing for privacy

### 3. Chat Feature (Grok AI)

**Purpose**: AI-powered fitness coaching

**Architecture**:
```
UI (ChatScreen) →
Controller (ChatController) →
Repository (ChatRepository) →
Service (GrokService) →
Grok API
```

**Key Components**:

1. **GrokService**: API integration
   - Handles HTTP requests to X.AI API
   - Model: grok-beta (configurable)
   - System prompt: Fitness coach persona
   - Conversation history management

2. **ChatRepository**: Business logic
   - Message formatting
   - Error handling
   - Response processing

3. **ChatController**: State management
   - Message list state
   - Loading states
   - User interaction handling

**API Integration**:
```dart
POST https://api.x.ai/v1/chat/completions
{
  "model": "grok-beta",
  "messages": [...],
  "temperature": 0.7,
  "max_tokens": 500
}
```

### 4. Profile Feature

**Purpose**: User settings and preferences

**Components**:
- User profile management
- App settings
- Workout statistics
- Preferences (notifications, voice coaching, etc.)

## Data Management

### Local Storage

**Hive**: NoSQL local database for:
- Workout history
- User preferences
- Offline data
- Exercise library

**SharedPreferences**: For simple key-value storage:
- API keys
- Settings flags
- Last login, etc.

### Models

Using **Freezed** for immutable data classes:

```dart
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String text,
    required bool isUser,
    required DateTime timestamp,
  }) = _ChatMessage;
}
```

Benefits:
- Immutability
- copyWith functionality
- Equality comparisons
- JSON serialization

## ML Integration

### Pose Detection Pipeline

1. **Camera Stream**: Continuous image capture
2. **Image Preprocessing**: Convert CameraImage to InputImage
3. **ML Inference**: Google ML Kit pose detection
4. **Post-processing**: Extract landmarks, calculate angles
5. **Analysis**: Determine muscle activation
6. **Visualization**: Draw overlays, show metrics

### Muscle Activation Algorithm

Current implementation (simplified):

```dart
Map<String, double> analyzeMuscleActivation(Pose pose, String exercise) {
  // Get relevant landmarks
  final landmarks = pose.landmarks;

  // Calculate joint angles
  final kneeAngle = calculateAngle(hip, knee, ankle);

  // Map angles to muscle activation
  return {
    'quadriceps': activationFromAngle(kneeAngle),
    'glutes': activationFromDepth(squatDepth),
    // ...
  };
}
```

**Future Enhancements**:
- Exercise-specific models
- Machine learning for activation estimation
- Real-time form feedback
- Rep counting

## API Integration

### Grok API

**Base URL**: `https://api.x.ai/v1`

**Authentication**: Bearer token

**Key Endpoints**:
- `POST /chat/completions`: Send messages

**Configuration**:
```dart
class GrokService {
  final String apiKey;

  GrokService({required this.apiKey}) {
    _dio.options.headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
  }
}
```

**Error Handling**:
- Network errors: Retry with exponential backoff
- API errors: Display user-friendly messages
- Rate limiting: Queue requests

## Testing Strategy

### Unit Tests

- Services: Mock API responses
- Repositories: Test business logic
- Controllers: Test state transitions
- Utilities: Test pure functions

### Widget Tests

- Screen rendering
- User interactions
- State updates
- Navigation

### Integration Tests

- Complete user flows
- API integration
- Camera + ML pipeline
- End-to-end scenarios

## Performance Optimization

### Camera/ML Performance

1. **Frame Throttling**: Process every Nth frame
2. **Resolution**: Use lower resolution for analysis
3. **Async Processing**: Non-blocking frame processing
4. **Model Selection**: Balance accuracy vs. speed

### State Management

1. **Selective Rebuilds**: Use `select` to watch specific values
2. **Provider Scope**: Limit provider scope when possible
3. **Lazy Loading**: Only load data when needed

### Build Size

1. **Code Splitting**: Use deferred loading for large features
2. **Asset Optimization**: Compress images
3. **Remove Unused Code**: Tree shaking

## Security Considerations

### API Key Management

- Never commit API keys
- Use environment variables
- Secure storage on device (encrypted SharedPreferences)
- Allow user to set key in-app

### Privacy

- On-device pose detection (no video sent to server)
- Optional data collection
- Clear privacy policy
- GDPR compliance

### Camera Access

- Request permissions properly
- Explain why permissions needed
- Handle permission denials gracefully

## Future Architecture Improvements

1. **Clean Architecture Layers**: Strictly separate domain from data
2. **Use Cases**: Implement use case classes for business logic
3. **Offline-First**: Full offline support with sync
4. **Modularization**: Split into multiple packages/modules
5. **CI/CD**: Automated testing and deployment
6. **Analytics**: Usage tracking and crash reporting
7. **A/B Testing**: Feature flags and experiments

## Development Guidelines

### Code Style

- Follow official [Flutter style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` before committing
- Keep widgets small and focused
- Extract reusable widgets to `shared/widgets/`

### Naming Conventions

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Constants: `lowerCamelCase`
- Private members: `_prefixedWithUnderscore`

### Git Workflow

- Feature branches: `feature/description`
- Bug fixes: `fix/description`
- Commit messages: Use conventional commits
- PR reviews required before merge

## Resources

- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Riverpod Documentation](https://riverpod.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Google ML Kit](https://developers.google.com/ml-kit/vision/pose-detection)
