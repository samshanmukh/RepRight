import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../shared/models/chat_message.dart';
import '../data/chat_repository.dart';

class ChatController extends StateNotifier<List<ChatMessage>> {
  final ChatRepository _repository;
  final _uuid = const Uuid();

  ChatController(this._repository) : super([]);

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = [...state, userMessage];

    // Add loading indicator
    final loadingMessage = ChatMessage(
      id: _uuid.v4(),
      text: '',
      isUser: false,
      timestamp: DateTime.now(),
      isLoading: true,
    );

    state = [...state, loadingMessage];

    try {
      // Get AI response
      final aiMessage = await _repository.sendMessage(text, state);

      // Remove loading indicator and add actual response
      state = [
        ...state.where((msg) => msg.id != loadingMessage.id),
        aiMessage,
      ];
    } catch (e) {
      // Remove loading indicator on error
      state = state.where((msg) => msg.id != loadingMessage.id).toList();

      // Add error message
      final errorMessage = ChatMessage(
        id: _uuid.v4(),
        text: 'Sorry, something went wrong. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
      );

      state = [...state, errorMessage];
    }
  }

  void clearChat() {
    state = [];
  }
}

final chatControllerProvider =
    StateNotifierProvider<ChatController, List<ChatMessage>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatController(repository);
});
