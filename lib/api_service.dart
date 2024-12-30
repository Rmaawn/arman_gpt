import 'dart:convert';
import 'package:http/http.dart' as http;

class Chat_GPT {
  static const String apiUrl =
      "https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill";

  final String apiKey;
  Chat_GPT(this.apiKey);

  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "inputs": message,
        "parameters": {
          "do_sample": true,
          "max_length": 50
        }
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List && jsonResponse.isNotEmpty) {
        return jsonResponse[0]['generated_text'] ?? 'No response';
      } else {
        return 'Unexpected response format';
      }
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }
}
