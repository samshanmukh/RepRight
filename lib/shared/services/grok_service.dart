import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GrokService {
  final Dio _dio;
  final String apiKey;

  GrokService({
    required this.apiKey,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = 'https://api.x.ai/v1';
    _dio.options.headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<String> sendMessage(
    String message, {
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      final messages = [
        {
          'role': 'system',
          'content':
              'You are a knowledgeable and supportive fitness coach. Provide helpful, accurate advice about workouts, exercises, form, nutrition, and fitness goals. Keep responses concise but informative. Be encouraging and motivational.',
        },
        if (conversationHistory != null) ...conversationHistory,
        {
          'role': 'user',
          'content': message,
        },
      ];

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'grok-beta',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 500,
        },
      );

      if (response.statusCode == 200) {
        final content = response.data['choices'][0]['message']['content'];
        return content as String;
      } else {
        throw Exception('Failed to get response from Grok API');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Grok API error: ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Stream<String>> streamMessage(
    String message, {
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      final messages = [
        {
          'role': 'system',
          'content':
              'You are a knowledgeable and supportive fitness coach. Provide helpful, accurate advice about workouts, exercises, form, nutrition, and fitness goals. Keep responses concise but informative. Be encouraging and motivational.',
        },
        if (conversationHistory != null) ...conversationHistory,
        {
          'role': 'user',
          'content': message,
        },
      ];

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'grok-beta',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 500,
          'stream': true,
        },
        options: Options(
          responseType: ResponseType.stream,
        ),
      );

      return (response.data as Stream).map((chunk) {
        final data = String.fromCharCodes(chunk);
        // Parse SSE format and extract content
        // This is a simplified version - actual implementation would need proper SSE parsing
        return data;
      });
    } catch (e) {
      throw Exception('Streaming error: $e');
    }
  }
}

// Riverpod provider for Grok service
final grokServiceProvider = Provider<GrokService>((ref) {
  // TODO: Load API key from environment or secure storage
  const apiKey = 'YOUR_GROK_API_KEY_HERE';
  return GrokService(apiKey: apiKey);
});
