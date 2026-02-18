/*
 * ----------------------------------------------------------------------------
 * KATMAN: SERVİS KATMANI (Service Layer / API Handling)
 * ----------------------------------------------------------------------------
 */
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = 'AIzaSyBwbuHlq3kGTaBzXk-AfiwX4uPvb_yRGTg';

  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  static const String _model = 'gemini-2.5-flash';

  Future<Map> analyzeMoodAndMotivate(String moodText) async {
    final url = Uri.parse('$_baseUrl/$_model:generateContent?key=$_apiKey');

    final prompt = '''
    Kullanıcı: "$moodText"
    
    Sen empatik, samimi ve pozitif bir yaşam koçusun. Kullanıcının girdisini analiz et ve aşağıdaki formatta yanıt ver.
    Cümlelerin yarım kalmamasına dikkat et, tam ve anlamlı cümleler kur.

    [ANALIZ]
    (Buraya kullanıcının duygusunu 2-3 cümle ile tespit et.)
    
    [TAVSIYE]
    (Buraya bu duygu durumuna özel, iç ısıtan, motive edici ve uygulanabilir 3-4 cümlelik bir tavsiye yaz.)
    
    [EMOJI]
    (Duyguya en uygun tek bir emoji koy, örn: 🌟)
    ''';

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 2048,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final text =
              data['candidates'][0]['content']['parts'][0]['text'] as String;
          return _parseResponse(text);
        } else {
          return _getErrorResponse();
        }
      } else {
        throw Exception('API Hatası: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Bağlantı sorunu: $e');
    }
  }

  Map _parseResponse(String text) {
    String getTagContent(String tag) {
      final regExp = RegExp('\\[$tag\\](.*?)(?=\\[|\$)', dotAll: true);
      final match = regExp.firstMatch(text);
      return match?.group(1)?.trim() ?? '';
    }

    String emotion = getTagContent('ANALIZ');
    String motivation = getTagContent('TAVSIYE');
    String emoji = getTagContent('EMOJI');

    if (emotion.isEmpty && motivation.isEmpty) {
      emotion = "Duygularını anlıyorum.";
      motivation = text.replaceAll(RegExp(r'\[.*?\]'), '').trim();
    }

    return {
      'emotion': emotion.isEmpty ? 'Duygular karmaşık.' : emotion,
      'motivation': motivation.isEmpty ? 'Kendine iyi bak.' : motivation,
      'emoji': emoji.isEmpty ? '✨' : emoji,
    };
  }

  Map _getErrorResponse() {
    return {
      'emotion': 'Analiz edilemedi',
      'motivation': 'Lütfen tekrar deneyin.',
      'emoji': '⚠️',
    };
  }
}
