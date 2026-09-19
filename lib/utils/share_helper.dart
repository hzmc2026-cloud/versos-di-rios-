import 'package:share_plus/share_plus.dart';
import 'package:versos_diarios/models/devotional.dart';
import 'package:versos_diarios/models/verse.dart';

/// Ajuda central de compartilhamento ("Enviar para alguém que precisa").
class ShareHelper {
  ShareHelper._();

  static const String appLink =
      '📱 Receba sua palavra diária no app Versos Diários: https://versosdiarios.com.br';

  /// Monta a mensagem formatada com frase afetiva + versículo + reflexão.
  static String buildVerseMessage(Verse verse, {String? reflection}) {
    final buffer = StringBuffer()
      ..writeln('Lembrei de você ao ler este versículo hoje:')
      ..writeln()
      ..writeln('"${verse.text}"')
      ..writeln('— ${verse.reference}');
    if (reflection != null && reflection.trim().isNotEmpty) {
      buffer
        ..writeln()
        ..writeln(reflection.trim());
    }
    buffer
      ..writeln()
      ..writeln(appLink);
    return buffer.toString();
  }

  static String buildDevotionalMessage(Devotional devotional) {
    return buildVerseMessage(
      devotional.verse,
      reflection: '${devotional.reflection}\n\n🙏 ${devotional.prayer}',
    );
  }

  /// Compartilha um versículo (com reflexão opcional).
  static Future<void> shareVerse(Verse verse, {String? reflection}) {
    return SharePlus.instance.share(
      ShareParams(text: buildVerseMessage(verse, reflection: reflection)),
    );
  }

  /// Compartilha um devocional completo.
  static Future<void> shareDevotional(Devotional devotional) {
    return SharePlus.instance.share(
      ShareParams(text: buildDevotionalMessage(devotional)),
    );
  }
}
