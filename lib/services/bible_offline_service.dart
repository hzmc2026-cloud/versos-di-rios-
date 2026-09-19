import 'dart:math';

import 'package:versos_diarios/models/verse.dart';

/// Repositório local de versículos para uso offline.
///
/// Versículos conhecidos categorizados por temas/sentimentos:
/// Ansiedade, Paz, Gratidão, Esperança, Direção, Família e Força.
class BibleOfflineService {
  BibleOfflineService._();

  static final Random _random = Random();

  static const List<Verse> _verses = [
    // --- Ansiedade ---
    Verse(
      id: 'ans-1',
      reference: 'Filipenses 4:6-7',
      text:
          'Não andeis ansiosos por coisa alguma; antes, em tudo, sejam os vossos pedidos conhecidos diante de Deus pela oração e súplica com ações de graças.',
      theme: VerseTheme.ansiedade,
    ),
    Verse(
      id: 'ans-2',
      reference: '1 Pedro 5:7',
      text:
          'Lançando sobre ele toda a vossa ansiedade, porque ele tem cuidado de vós.',
      theme: VerseTheme.ansiedade,
    ),
    Verse(
      id: 'ans-3',
      reference: 'Mateus 6:34',
      text:
          'Não vos inquieteis, pois, pelo dia de amanhã, porque o dia de amanhã cuidará de si mesmo. Basta a cada dia o seu mal.',
      theme: VerseTheme.ansiedade,
    ),

    // --- Paz ---
    Verse(
      id: 'paz-1',
      reference: 'João 14:27',
      text:
          'Deixo-vos a paz, a minha paz vos dou; não vo-la dou como o mundo a dá. Não se turbe o vosso coração, nem se atemorize.',
      theme: VerseTheme.paz,
    ),
    Verse(
      id: 'paz-2',
      reference: 'Isaías 26:3',
      text:
          'Tu conservarás em paz aquele cuja mente está firme em ti; porque ele confia em ti.',
      theme: VerseTheme.paz,
    ),
    Verse(
      id: 'paz-3',
      reference: 'Salmos 4:8',
      text:
          'Em paz também me deitarei e dormirei, porque só tu, Senhor, me fazes habitar em segurança.',
      theme: VerseTheme.paz,
    ),

    // --- Gratidão ---
    Verse(
      id: 'grat-1',
      reference: '1 Tessalonicenses 5:18',
      text:
          'Em tudo dai graças, porque esta é a vontade de Deus em Cristo Jesus para convosco.',
      theme: VerseTheme.gratidao,
    ),
    Verse(
      id: 'grat-2',
      reference: 'Salmos 100:4',
      text:
          'Entrai pelas portas dele com gratidão, e em seus átrios com louvor; louvai-o, e bendizei o seu nome.',
      theme: VerseTheme.gratidao,
    ),
    Verse(
      id: 'grat-3',
      reference: 'Colossenses 3:17',
      text:
          'E, quanto fizerdes por palavras ou por obras, fazei tudo em nome do Senhor Jesus, dando por ele graças a Deus Pai.',
      theme: VerseTheme.gratidao,
    ),

    // --- Esperança ---
    Verse(
      id: 'esp-1',
      reference: 'Jeremias 29:11',
      text:
          'Porque eu bem sei os pensamentos que tenho a vosso respeito, diz o Senhor: pensamentos de paz, e não de mal, para vos dar o fim que esperais.',
      theme: VerseTheme.esperanca,
    ),
    Verse(
      id: 'esp-2',
      reference: 'Romanos 15:13',
      text:
          'Ora, o Deus de esperança vos encha de todo o gozo e paz em crença, para que abundeis em esperança pela virtude do Espírito Santo.',
      theme: VerseTheme.esperanca,
    ),
    Verse(
      id: 'esp-3',
      reference: 'Salmos 42:11',
      text:
          'Por que estás abatida, ó minha alma, e por que te perturbas dentro de mim? Espera em Deus, pois ainda o louvarei.',
      theme: VerseTheme.esperanca,
    ),

    // --- Direção ---
    Verse(
      id: 'dir-1',
      reference: 'Provérbios 3:5-6',
      text:
          'Confia no Senhor de todo o teu coração, e não te estribes no teu próprio entendimento. Reconhece-o em todos os teus caminhos, e ele endireitará as tuas veredas.',
      theme: VerseTheme.direcao,
    ),
    Verse(
      id: 'dir-2',
      reference: 'Salmos 32:8',
      text:
          'Instruir-te-ei, e ensinar-te-ei o caminho que deves seguir; guiar-te-ei com os meus olhos.',
      theme: VerseTheme.direcao,
    ),
    Verse(
      id: 'dir-3',
      reference: 'Tiago 1:5',
      text:
          'E, se algum de vós tem falta de sabedoria, peça-a a Deus, que a todos dá liberalmente, e o não lança em rosto, e ser-lhe-á dada.',
      theme: VerseTheme.direcao,
    ),

    // --- Família ---
    Verse(
      id: 'fam-1',
      reference: 'Josué 24:15',
      text:
          'Eu e a minha casa serviremos ao Senhor.',
      theme: VerseTheme.familia,
    ),
    Verse(
      id: 'fam-2',
      reference: 'Provérbios 22:6',
      text:
          'Instrui o menino no caminho em que deve andar, e até quando envelhecer não se desviará dele.',
      theme: VerseTheme.familia,
    ),
    Verse(
      id: 'fam-3',
      reference: 'Salmos 133:1',
      text:
          'Oh! Quão bom e quão suave é que os irmãos vivam em união.',
      theme: VerseTheme.familia,
    ),

    // --- Força ---
    Verse(
      id: 'for-1',
      reference: 'Isaías 40:31',
      text:
          'Mas os que esperam no Senhor renovarão as forças, subirão com asas como águias; correrão, e não se cansarão; caminharão, e não se fatigarão.',
      theme: VerseTheme.forca,
    ),
    Verse(
      id: 'for-2',
      reference: 'Filipenses 4:13',
      text: 'Posso todas as coisas em Cristo que me fortalece.',
      theme: VerseTheme.forca,
    ),
    Verse(
      id: 'for-3',
      reference: 'Salmos 46:1',
      text:
          'Deus é o nosso refúgio e fortaleza, socorro bem presente na angústia.',
      theme: VerseTheme.forca,
    ),
  ];

  /// Todos os versículos do repositório local.
  static List<Verse> getAll() => List<Verse>.unmodifiable(_verses);

  /// Todos os temas disponíveis.
  static List<VerseTheme> getThemes() => VerseTheme.values;

  /// Versículos filtrados por [theme].
  static List<Verse> getByTheme(VerseTheme theme) {
    return _verses.where((v) => v.theme == theme).toList();
  }

  /// Um versículo aleatório do tema informado.
  static Verse getRandomByTheme(VerseTheme theme) {
    final list = getByTheme(theme);
    if (list.isEmpty) return _verses.first;
    return list[_random.nextInt(list.length)];
  }

  /// Um versículo aleatório qualquer.
  static Verse getRandom() => _verses[_random.nextInt(_verses.length)];

  /// Versículo do dia: determinístico a partir da data (mesmo verso o dia todo).
  static Verse getVerseOfDay([DateTime? date]) {
    final now = date ?? DateTime.now();
    final seed =
        now.year * 10000 + now.month * 100 + now.day; // ex: 20260131
    final index = seed % _verses.length;
    return _verses[index];
  }
}
