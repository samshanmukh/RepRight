import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/chat_message.dart';
import '../../../shared/services/grok_service.dart';
import 'package:uuid/uuid.dart';

class ChatRepository {
  final GrokService _grokService;
  final _uuid = const Uuid();

  ChatRepository(this._grokService);

  Future<ChatMessage> sendMessage(
    String text,
    List<ChatMessage> conversationHistory,
  ) async {
    try {
      // Convert conversation history to format expected by Grok API
      final history = conversationHistory.map((msg) {
        return {
          'role': msg.isUser ? 'user' : 'assistant',
          'content': msg.text,
        };
      }).toList();

      final response = await _grokService.sendMessage(
        text,
        conversationHistory: history,
      );

      return ChatMessage(
        id: _uuid.v4(),
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      // Return error message
      return ChatMessage(
        id: _uuid.v4(),
        text: 'Sorry, I encountered an error: ${e.toString()}. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
      );
    }
  }
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final grokService = ref.watch(grokServiceProvider);
  return ChatRepository(grokService);
});
