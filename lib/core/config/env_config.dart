import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnvConfig {
  static const String _grokApiKeyKey = 'GROK_API_KEY';

  static Future<String?> getGrokApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_grokApiKeyKey);
  }

  static Future<void> setGrokApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_grokApiKeyKey, apiKey);
  }

  static Future<bool> hasGrokApiKey() async {
    final apiKey = await getGrokApiKey();
    return apiKey != null && apiKey.isNotEmpty;
  }
}

// Provider for API key
final grokApiKeyProvider = FutureProvider<String?>((ref) async {
  return await EnvConfig.getGrokApiKey();
});
