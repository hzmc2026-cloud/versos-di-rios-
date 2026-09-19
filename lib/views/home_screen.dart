import 'package:flutter/material.dart';
import 'package:versos_diarios/models/verse.dart';
import 'package:versos_diarios/services/bible_offline_service.dart';
import 'package:versos_diarios/views/card_creator_screen.dart';
import 'package:versos_diarios/views/devotional_screen.dart';
import 'package:versos_diarios/widgets/app_button.dart';
import 'package:versos_diarios/widgets/section_title.dart';
import 'package:versos_diarios/widgets/theme_selector.dart';
import 'package:versos_diarios/widgets/verse_card.dart';

/// Tela principal do aplicativo.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Verse _verseOfDay;
  VerseTheme? _selectedTheme;
  List<Verse> _themeVerses = [];

  @override
  void initState() {
    super.initState();
    _verseOfDay = BibleOfflineService.getVerseOfDay();
  }

  void _onThemeSelected(VerseTheme theme) {
    setState(() {
      _selectedTheme = theme;
      _themeVerses = BibleOfflineService.getByTheme(theme);
    });
  }

  void _refreshVerseOfDay() {
    setState(() {
      if (_selectedTheme == null) {
        _verseOfDay = BibleOfflineService.getRandom();
      } else {
        _verseOfDay = BibleOfflineService.getRandomByTheme(_selectedTheme!);
      }
    });
  }

  void _openDevotional(Verse verse) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DevotionalScreen(initialVerse: verse)),
    );
  }

  void _openCardCreator(Verse verse) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CardCreatorScreen(verse: verse)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_stories_outlined),
            SizedBox(width: 8),
            Text('Versos Diários'),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: 'Versículo do dia',
              subtitle: 'Uma palavra para começar bem o seu dia',
            ),
            const SizedBox(height: 12),
            VerseCard(verse: _verseOfDay),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Receber devocional',
                    icon: Icons.spa_outlined,
                    onPressed: () => _openDevotional(_verseOfDay),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filledTonal(
                  tooltip: 'Outro versículo',
                  onPressed: _refreshVerseOfDay,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Criar cartão',
                icon: Icons.share_outlined,
                outlined: true,
                onPressed: () => _openCardCreator(_verseOfDay),
              ),
            ),
            const SizedBox(height: 24),
            const SectionTitle(
              title: 'Como está seu coração hoje?',
              subtitle: 'Escolha um tema e encontre uma palavra',
            ),
            const SizedBox(height: 8),
            ThemeSelector(
              selected: _selectedTheme,
              onSelected: _onThemeSelected,
            ),
            const SizedBox(height: 12),
            if (_selectedTheme != null) ...[
              Text(
                _selectedTheme!.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              for (final verse in _themeVerses)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: VerseCard(
                    verse: verse,
                    onTap: () => _openDevotional(verse),
                  ),
                ),
            ] else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: const Text(
                  'Toque em um tema acima para ver versículos de conforto, direção e esperança.',
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
