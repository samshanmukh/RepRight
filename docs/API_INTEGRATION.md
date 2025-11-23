# Grok API Integration Guide

## Overview

Fit Buddy integrates with the Grok AI API (by X.AI) to provide intelligent fitness coaching through a chat interface. This document covers the integration details, configuration, and usage.

## API Details

### Endpoint

```
Base URL: https://api.x.ai/v1
Endpoint: POST /chat/completions
```

### Authentication

The API uses Bearer token authentication:

```http
Authorization: Bearer YOUR_API_KEY
Content-Type: application/json
```

### Getting an API Key

1. Visit [console.x.ai](https://console.x.ai/)
2. Sign up or log in
3. Navigate to API Keys section
4. Create a new API key
5. Copy and securely store the key

## Integration Architecture

### Service Layer

**File**: `lib/shared/services/grok_service.dart`

```dart
class GrokService {
  final Dio _dio;
  final String apiKey;

  GrokService({required this.apiKey}) {
    _dio = Dio();
    _dio.options.baseUrl = 'https://api.x.ai/v1';
    _dio.options.headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
  }

  Future<String> sendMessage(
    String message,
    {List<Map<String, String>>? conversationHistory}
  ) async {
    final response = await _dio.post('/chat/completions', data: {
      'model': 'grok-beta',
      'messages': messages,
      'temperature': 0.7,
      'max_tokens': 500,
    });

    return response.data['choices'][0]['message']['content'];
  }
}
```

### Repository Layer

**File**: `lib/features/chat/data/chat_repository.dart`

Handles business logic:
- Message formatting
- Conversation history management
- Error handling

### Controller Layer

**File**: `lib/features/chat/presentation/chat_controller.dart`

Manages UI state:
- Message list
- Loading states
- User interactions

## API Request/Response

### Request Format

```json
{
  "model": "grok-beta",
  "messages": [
    {
      "role": "system",
      "content": "You are a fitness coach..."
    },
    {
      "role": "user",
      "content": "How do I improve my squat form?"
    }
  ],
  "temperature": 0.7,
  "max_tokens": 500
}
```

### Response Format

```json
{
  "id": "chatcmpl-123",
  "object": "chat.completion",
  "created": 1677652288,
  "model": "grok-beta",
  "choices": [{
    "index": 0,
    "message": {
      "role": "assistant",
      "content": "To improve your squat form..."
    },
    "finish_reason": "stop"
  }],
  "usage": {
    "prompt_tokens": 56,
    "completion_tokens": 100,
    "total_tokens": 156
  }
}
```

## Configuration

### Model Selection

The default model is `grok-beta`. To use the fast reasoning model, update `grok_service.dart`:

```dart
final response = await _dio.post('/chat/completions', data: {
  'model': 'grok-4-1-fast-reasoning',  // Updated model
  // ...
});
```

### Available Models

- `grok-beta`: Standard Grok model
- `grok-4-1-fast-reasoning`: Fast reasoning model (recommended)
- Check X.AI docs for latest models

### System Prompt

The system prompt defines the AI's behavior. Current prompt:

```dart
{
  'role': 'system',
  'content': 'You are a knowledgeable and supportive fitness coach. '
             'Provide helpful, accurate advice about workouts, exercises, '
             'form, nutrition, and fitness goals. Keep responses concise '
             'but informative. Be encouraging and motivational.'
}
```

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `temperature` | 0.7 | Controls randomness (0-1) |
| `max_tokens` | 500 | Maximum response length |
| `top_p` | 1.0 | Nucleus sampling parameter |
| `frequency_penalty` | 0.0 | Reduces repetition (-2 to 2) |
| `presence_penalty` | 0.0 | Encourages new topics (-2 to 2) |

Adjust in `grok_service.dart` as needed:

```dart
data: {
  'model': 'grok-beta',
  'messages': messages,
  'temperature': 0.7,
  'max_tokens': 1000,  // Longer responses
  'frequency_penalty': 0.3,  // Less repetitive
}
```

## Conversation Management

### Conversation History

To maintain context, send previous messages:

```dart
final messages = [
  {'role': 'system', 'content': 'You are a fitness coach...'},
  {'role': 'user', 'content': 'What exercises for chest?'},
  {'role': 'assistant', 'content': 'For chest, I recommend...'},
  {'role': 'user', 'content': 'How many sets?'},  // Current question
];
```

### History Limits

To manage costs and context length:

```dart
// Keep only last N messages
const maxHistoryMessages = 10;
final recentHistory = conversationHistory.take(maxHistoryMessages).toList();
```

## Error Handling

### Common Errors

1. **401 Unauthorized**: Invalid API key
2. **429 Too Many Requests**: Rate limit exceeded
3. **500 Server Error**: API service issue
4. **Network errors**: No internet connection

### Implementation

```dart
try {
  final response = await _dio.post('/chat/completions', data: data);
  return response.data['choices'][0]['message']['content'];
} on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    throw Exception('Invalid API key');
  } else if (e.response?.statusCode == 429) {
    throw Exception('Rate limit exceeded. Please try again later.');
  } else {
    throw Exception('Failed to get response: ${e.message}');
  }
}
```

### User-Friendly Messages

In `ChatRepository`:

```dart
Future<ChatMessage> sendMessage(String text, ...) async {
  try {
    final response = await _grokService.sendMessage(text, ...);
    return ChatMessage(text: response, isUser: false, ...);
  } catch (e) {
    return ChatMessage(
      text: 'Sorry, I encountered an error. Please check your '
            'internet connection and API key.',
      isUser: false,
      ...
    );
  }
}
```

## Rate Limiting

### X.AI Rate Limits

Check [X.AI documentation](https://docs.x.ai/) for current limits.

Typical limits:
- Requests per minute: 60
- Tokens per minute: 60,000

### Handling Rate Limits

Implement exponential backoff:

```dart
Future<String> sendMessageWithRetry(String message) async {
  int retries = 0;
  const maxRetries = 3;

  while (retries < maxRetries) {
    try {
      return await sendMessage(message);
    } catch (e) {
      if (isRateLimitError(e)) {
        retries++;
        await Future.delayed(Duration(seconds: pow(2, retries)));
      } else {
        rethrow;
      }
    }
  }

  throw Exception('Max retries exceeded');
}
```

## Cost Management

### Token Usage

Monitor token usage to manage costs:

```dart
final usage = response.data['usage'];
print('Prompt tokens: ${usage['prompt_tokens']}');
print('Completion tokens: ${usage['completion_tokens']}');
print('Total tokens: ${usage['total_tokens']}');
```

### Cost Optimization

1. **Limit max_tokens**: Set appropriate response length
2. **Trim history**: Keep only recent messages
3. **Cache responses**: Store common Q&A
4. **User limits**: Limit messages per user/day

## Testing

### Mock Service

Create a mock for testing:

```dart
class MockGrokService extends GrokService {
  MockGrokService() : super(apiKey: 'test-key');

  @override
  Future<String> sendMessage(String message, ...) async {
    await Future.delayed(Duration(seconds: 1));
    return 'This is a mock response for: $message';
  }
}
```

### Integration Tests

Test with real API (use test environment):

```dart
void main() {
  test('Grok service returns valid response', () async {
    final service = GrokService(apiKey: testApiKey);
    final response = await service.sendMessage('Hello');

    expect(response, isNotEmpty);
    expect(response, isA<String>());
  });
}
```

## Security Best Practices

### API Key Storage

❌ **Never**:
```dart
const apiKey = 'sk-xxx-your-key';  // Hardcoded!
```

✅ **Always**:
```dart
// From environment/config
final apiKey = await EnvConfig.getGrokApiKey();

// Or from secure storage
final storage = FlutterSecureStorage();
final apiKey = await storage.read(key: 'grok_api_key');
```

### User-Provided Keys

Allow users to set their own API key:

```dart
// In settings screen
Future<void> saveApiKey(String apiKey) async {
  await EnvConfig.setGrokApiKey(apiKey);
  // Reinitialize service with new key
  ref.invalidate(grokServiceProvider);
}
```

### Environment Variables

Use different keys for dev/prod:

```dart
class EnvConfig {
  static String get grokApiKey {
    return const String.fromEnvironment(
      'GROK_API_KEY',
      defaultValue: 'your-dev-key',
    );
  }
}
```

## Advanced Features

### Streaming Responses

For real-time response streaming:

```dart
Future<Stream<String>> streamMessage(String message) async {
  final response = await _dio.post(
    '/chat/completions',
    data: {
      'model': 'grok-beta',
      'messages': messages,
      'stream': true,  // Enable streaming
    },
    options: Options(responseType: ResponseType.stream),
  );

  return response.data.map((chunk) {
    // Parse SSE format
    return extractContent(chunk);
  });
}
```

### Function Calling

If Grok supports function calling:

```dart
data: {
  'model': 'grok-beta',
  'messages': messages,
  'functions': [
    {
      'name': 'get_exercise_info',
      'description': 'Get details about an exercise',
      'parameters': {
        'type': 'object',
        'properties': {
          'exercise_name': {'type': 'string'},
        },
      },
    },
  ],
}
```

## Troubleshooting

### API Key Issues

**Problem**: 401 Unauthorized

**Solutions**:
1. Verify API key is correct
2. Check key hasn't expired
3. Ensure no extra whitespace in key
4. Regenerate key in X.AI console

### Timeout Errors

**Problem**: Request timeout

**Solutions**:
```dart
_dio.options.connectTimeout = Duration(seconds: 30);
_dio.options.receiveTimeout = Duration(seconds: 60);
```

### JSON Parsing Errors

**Problem**: Unexpected response format

**Solutions**:
1. Log raw response for debugging
2. Add try-catch around JSON parsing
3. Validate response structure before parsing

## Resources

- [X.AI API Documentation](https://docs.x.ai/)
- [X.AI Console](https://console.x.ai/)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [Riverpod Docs](https://riverpod.dev/)

## Support

For API-related issues:
- Check [X.AI status page](https://status.x.ai/)
- Contact X.AI support
- Check community forums
