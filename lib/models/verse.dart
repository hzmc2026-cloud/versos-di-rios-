/// Modelo que representa um versículo bíblico.
class Verse {
  final String id;
  final String reference;
  final String text;
  final VerseTheme theme;
  final String version;

  const Verse({
    required this.id,
    required this.reference,
    required this.text,
    required this.theme,
    this.version = 'ACF',
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'] as String,
      reference: json['reference'] as String,
      text: json['text'] as String,
      theme: VerseTheme.fromName(json['theme'] as String),
      version: json['version'] as String? ?? 'ACF',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'text': text,
      'theme': theme.name,
      'version': version,
    };
  }
}

/// Temas/sentimentos usados para categorizar os versículos offline.
enum VerseTheme {
  ansiedade,
  paz,
  gratidao,
  esperanca,
  direcao,
  familia,
  forca;

  static VerseTheme fromName(String name) {
    return VerseTheme.values.firstWhere(
      (e) => e.name == name,
      orElse: () => VerseTheme.esperanca,
    );
  }

  String get label {
    switch (this) {
      case VerseTheme.ansiedade:
        return 'Ansiedade';
      case VerseTheme.paz:
        return 'Paz';
      case VerseTheme.gratidao:
        return 'Gratidão';
      case VerseTheme.esperanca:
        return 'Esperança';
      case VerseTheme.direcao:
        return 'Direção';
      case VerseTheme.familia:
        return 'Família';
      case VerseTheme.forca:
        return 'Força';
    }
  }

  String get description {
    switch (this) {
      case VerseTheme.ansiedade:
        return 'Para corações aflitos e preocupados';
      case VerseTheme.paz:
        return 'Para descansar em Deus';
      case VerseTheme.gratidao:
        return 'Para um coração grato';
      case VerseTheme.esperanca:
        return 'Para renovar a esperança';
      case VerseTheme.direcao:
        return 'Para decisões e caminhos';
      case VerseTheme.familia:
        return 'Para o lar e os relacionamentos';
      case VerseTheme.forca:
        return 'Para dias de cansaço e luta';
    }
  }
}
