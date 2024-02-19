import 'package:http/http.dart' as http;
import 'package:diary_plus/api_service/chat_request.dart';
import 'package:diary_plus/api_service/chat_response.dart';
import 'api_key.dart';

class ChatService {
  static final Uri chatUri =
      Uri.parse('https://api.openai.com/v1/chat/completions');

  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${ApiKey.openAIApiKey}',
  };

  Future<String?> request(String prompt) async {
    try {
      ChatRequest request = ChatRequest(
        model: "gpt-3.5-turbo",
        maxTokens: 3882,
        messages: [Message(role: "assistant", content: prompt)],
        temperature: 1,
        topP: 1,
        frequencyPenalty: 0,
        presencePenalty: 0,
        n: 1,
      );
      if (prompt.isEmpty) {
        return "empty";
      }
      http.Response response = await http.post(
        chatUri,
        headers: headers,
        body: request.toJson(),
      );
      ChatResponse chatResponse = ChatResponse.fromResponse(response);
      return (chatResponse.choices?[0].message?.content);
    } catch (e) {
      print("error $e");
    }
    return "failed";
  }
}
