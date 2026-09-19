import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:versos_diarios/models/devotional.dart';
import 'package:versos_diarios/models/verse.dart';

/// Serviço de integração com a API do Google Gemini.
///
/// A chave é injetada em tempo de compilação via:
/// `--dart-define=GEMINI_API_KEY="sua_chave_aqui"`
///
/// Exemplo de execução:
/// `flutter run --dart-define=GEMINI_API_KEY="AIza..."`.
class GeminiService {
  /// Chave lida via `--dart-define`.
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  static const String _model = 'gemini-2.0-flash';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  /// Prompt de sistema: tom acolhedor, respeitoso, pastoral e prático.
  static const String systemPrompt = '''
Você é um guia devocional cristão acolhedor, respeitoso e pastoral do aplicativo "Versos Diários".

Diretrizes obrigatórias:
1. Seja sempre acolhedor, gentil e encorajador. Nunca julgue o leitor.
2. Respeite todas as pessoas e tradições cristãs; evite polêmicas teológicas, políticas ou doutrinárias divisivas.
3. Use linguagem simples, calorosa e pastoral, como um pastor cuidadoso falando ao coração.
4. Estruture toda reflexão devocional em 4 partes curtas:
   - Título inspirador
   - Reflexão (2 a 4 parágrafos curtos sobre o versículo)
   - Atitude prática para o dia (1 ação concreta e possível hoje)
   - Oração curta (2 a 4 frases)
5. Conecte o versículo com atitudes práticas do dia a dia: família, trabalho, descanso, gratidão, perdão e esperança.
6. Nunca invente referências bíblicas; use apenas o versículo fornecido pelo usuário.
7. Responda sempre em português do Brasil.
''';

  /// Indica se há uma chave configurada.
  bool get hasApiKey => _apiKey.isNotEmpty;

  /// Gera um devocional a partir de um [verse].
  ///
  /// Lança [GeminiException] em caso de falha. O chamador pode então
  /// usar [Devotional.fallback] para operar offline.
  Future<Devotional> generateDevotional(Verse verse) async {
    if (!hasApiKey) {
      throw const GeminiException(
        'Chave da API não configurada. Execute com --dart-define=GEMINI_API_KEY="..."',
      );
    }

    final userPrompt = '''
Com base neste versículo, escreva um devocional seguindo as 4 partes (título, reflexão, atitude prática, oração):

Referência: ${verse.reference}
Texto: "${verse.text}"
Tema: ${verse.theme.label}

Responda ESTRITAMENTE neste formato JSON (sem markdown, sem crases):
{"title": "...", "reflection": "...", "practicalAttitude": "...", "prayer": "..."}
''';

    final raw = await _generateContent(userPrompt);
    final parsed = _extractJson(raw);

    return Devotional(
      id: 'ai-${DateTime.now().millisecondsSinceEpoch}',
      title: parsed['title'] as String? ?? 'Reflexão sobre ${verse.reference}',
      verse: verse,
      reflection: parsed['reflection'] as String? ?? raw,
      practicalAttitude:
          parsed['practicalAttitude'] as String? ?? 'Ore e medite neste versículo hoje.',
      prayer: parsed['prayer'] as String? ?? 'Senhor, guia meu dia. Amém.',
      date: DateTime.now(),
    );
  }

  /// Gera um devocional a partir do sentimento/tema descrito pelo usuário.
  Future<Devotional> generateDevotionalForFeeling(
    String feeling,
    Verse verse,
  ) async {
    if (!hasApiKey) {
      throw const GeminiException(
        'Chave da API não configurada. Execute com --dart-define=GEMINI_API_KEY="..."',
      );
    }

    final userPrompt = '''
O leitor está se sentindo assim: "$feeling".
Tema relacionado: ${verse.theme.label}.
Versículo base — ${verse.reference}: "${verse.text}"

Escreva um devocional pastoral e acolhedor conectado ao sentimento do leitor.

Responda ESTRITAMENTE neste formato JSON (sem markdown, sem crases):
{"title": "...", "reflection": "...", "practicalAttitude": "...", "prayer": "..."}
''';

    final raw = await _generateContent(userPrompt);
    final parsed = _extractJson(raw);

    return Devotional(
      id: 'ai-${DateTime.now().millisecondsSinceEpoch}',
      title: parsed['title'] as String? ?? 'Deus cuida de você',
      verse: verse,
      reflection: parsed['reflection'] as String? ?? raw,
      practicalAttitude:
          parsed['practicalAttitude'] as String? ?? 'Reserve um momento de oração hoje.',
      prayer: parsed['prayer'] as String? ?? 'Senhor, acalma meu coração. Amém.',
      date: DateTime.now(),
    );
  }

  Future<String> _generateContent(String userPrompt) async {
    final uri = Uri.parse('$_baseUrl/$_model:generateContent?key=$_apiKey');

    final body = jsonEncode({
      'system_instruction': {
        'parts': [
          {'text': systemPrompt},
        ],
      },
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': userPrompt},
          ],
        },
      ],
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 1024,
      },
    });

    http.Response response;
    try {
      response = await http
          .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      throw GeminiException('Falha de conexão com a IA: $e');
    }

    if (response.statusCode != 200) {
      throw GeminiException(
        'Gemini retornou status ${response.statusCode}: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = decoded['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw const GeminiException('Resposta vazia da IA.');
    }

    final content = candidates.first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;
    if (parts == null || parts.isEmpty) {
      throw const GeminiException('Resposta da IA sem conteúdo.');
    }

    return (parts.first['text'] as String? ?? '').trim();
  }

  /// Extrai o objeto JSON da resposta (tolerando texto extra ao redor).
  Map<String, dynamic> _extractJson(String raw) {
    try {
      final start = raw.indexOf('{');
      final end = raw.lastIndexOf('}');
      if (start == -1 || end == -1 || end <= start) {
        return {'reflection': raw};
      }
      final slice = raw.substring(start, end + 1);
      return jsonDecode(slice) as Map<String, dynamic>;
    } catch (_) {
      return {'reflection': raw};
    }
  }
}

/// Erro lançado pelo [GeminiService].
class GeminiException implements Exception {
  final String message;
  const GeminiException(this.message);

  @override
  String toString() => 'GeminiException: $message';
}
