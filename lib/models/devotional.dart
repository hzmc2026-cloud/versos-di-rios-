import 'package:versos_diarios/models/verse.dart';

/// Modelo que representa um devocional gerado (via IA ou fallback offline).
class Devotional {
  final String id;
  final String title;
  final Verse verse;
  final String reflection;
  final String practicalAttitude;
  final String prayer;
  final DateTime date;

  const Devotional({
    required this.id,
    required this.title,
    required this.verse,
    required this.reflection,
    required this.practicalAttitude,
    required this.prayer,
    required this.date,
  });

  /// Devocional de fallback usado quando a IA está indisponível (offline).
  factory Devotional.fallback(Verse verse) {
    return Devotional(
      id: 'fallback-${verse.id}',
      title: 'Reflexão sobre ${verse.reference}',
      verse: verse,
      reflection:
          'Este versículo nos lembra que Deus está presente em todos os momentos. '
          'Medite com calma em cada palavra e permita que ela traga consolo ao seu coração.',
      practicalAttitude:
          'Hoje, reserve 5 minutos em silêncio, respire fundo e ore entregando '
          'a Deus aquilo que preocupa o seu coração.',
      prayer:
          'Senhor, obrigado pela Tua Palavra. Acalma o meu coração e guia os meus '
          'passos neste dia. Amém.',
      date: DateTime.now(),
    );
  }

  factory Devotional.fromJson(Map<String, dynamic> json, Verse verse) {
    return Devotional(
      id: json['id'] as String,
      title: json['title'] as String,
      verse: verse,
      reflection: json['reflection'] as String,
      practicalAttitude: json['practicalAttitude'] as String,
      prayer: json['prayer'] as String,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'verse': verse.toJson(),
      'reflection': reflection,
      'practicalAttitude': practicalAttitude,
      'prayer': prayer,
      'date': date.toIso8601String(),
    };
  }
}
