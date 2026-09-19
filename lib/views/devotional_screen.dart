import 'package:flutter/material.dart';
import 'package:versos_diarios/models/devotional.dart';
import 'package:versos_diarios/models/verse.dart';
import 'package:versos_diarios/services/bible_offline_service.dart';
import 'package:versos_diarios/services/gemini_service.dart';
import 'package:versos_diarios/utils/share_helper.dart';
import 'package:versos_diarios/views/card_creator_screen.dart';
import 'package:versos_diarios/widgets/app_button.dart';
import 'package:versos_diarios/widgets/section_title.dart';
import 'package:versos_diarios/widgets/theme_selector.dart';
import 'package:versos_diarios/widgets/verse_card.dart';

/// Tela de devocional com geração via IA (Gemini) e fallback offline.
class DevotionalScreen extends StatefulWidget {
  final Verse? initialVerse;

  const DevotionalScreen({super.key, this.initialVerse});

  static const routeName = '/devotional';

  @override
  State<DevotionalScreen> createState() => _DevotionalScreenState();
}

class _DevotionalScreenState extends State<DevotionalScreen> {
  final GeminiService _gemini = GeminiService();
  final TextEditingController _feelingController = TextEditingController();

  late Verse _verse;
  VerseTheme _theme = VerseTheme.esperanca;
  Devotional? _devotional;
  bool _loading = false;
  String? _error;
  bool _usedFallback = false;

  @override
  void initState() {
    super.initState();
    _verse = widget.initialVerse ?? BibleOfflineService.getVerseOfDay();
    _theme = _verse.theme;
  }

  @override
  void dispose() {
    _feelingController.dispose();
    super.dispose();
  }

  void _onThemeChanged(VerseTheme theme) {    setState(() {
      _theme = theme;
      _verse = BibleOfflineService.getRandomByTheme(theme);
      _devotional = null;
      _error = null;
      _usedFallback = false;
    });
  }

  Future<void> _generate() async {
    setState(() {
      _loading = true;
      _error = null;
      _usedFallback = false;
    });
    try {
      final feeling = _feelingController.text.trim();
      final Devotional result;
      if (feeling.isEmpty) {
        result = await _gemini.generateDevotional(_verse);
      } else {
        result = await _gemini.generateDevotionalForFeeling(feeling, _verse);
      }
      if (!mounted) return;
      setState(() => _devotional = result);
    } on GeminiException catch (e) {
      if (!mounted) return;
      setState(() {
        _devotional = Devotional.fallback(_verse);
        _usedFallback = true;
        _error = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _devotional = Devotional.fallback(_verse);
        _usedFallback = true;
        _error = 'Não foi possível conectar à IA. Mostrando reflexão offline. ($e)';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Compartilha o devocional atual ("Enviar para quem precisa").
  Future<void> _shareDevotional() {
    final devotional = _devotional;
    if (devotional != null) {
      return ShareHelper.shareDevotional(devotional);
    }
    return ShareHelper.shareVerse(_verse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Devocional do dia')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: 'Escolha um tema',
              subtitle: 'A IA refletirá sobre um versículo deste tema',
            ),
            ThemeSelector(selected: _theme, onSelected: _onThemeChanged),
            const SizedBox(height: 12),
            VerseCard(verse: _verse),
            const SizedBox(height: 16),
            TextField(
              controller: _feelingController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Como você está se sentindo? (opcional)',
                hintText: 'Ex.: ansioso com o trabalho, grato pela família...',
                prefixIcon: Icon(Icons.edit_note_outlined),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: _loading ? 'Gerando...' : 'Gerar devocional com IA',
                icon: Icons.auto_awesome_outlined,
                onPressed: _loading ? null : _generate,
              ),
            ),
            if (!_gemini.hasApiKey)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Dica: execute o app com --dart-define=GEMINI_API_KEY="..." para ativar a IA. Sem a chave, usamos a reflexão offline.',
                  style: TextStyle(fontSize: 12, color: Colors.brown),
                ),
              ),
            const SizedBox(height: 20),
            if (_loading) const Center(child: CircularProgressIndicator()),
            if (_error != null && _usedFallback)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(_error!, style: const TextStyle(fontSize: 13)),
              ),
            if (_devotional != null && !_loading) _buildDevotionalCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildDevotionalCard() {
    final devotional = _devotional!;
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_usedFallback)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Modo offline',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            Text(
              devotional.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              devotional.verse.reference,
              style: theme.textTheme.labelLarge?.copyWith(
                color: const Color(0xFFD97706),
              ),
            ),
            const Divider(height: 24),
            _block('Reflexão', devotional.reflection, Icons.menu_book_outlined),
            _block(
              'Atitude prática para hoje',
              devotional.practicalAttitude,
              Icons.check_circle_outline,
            ),
            _block('Oração', devotional.prayer, Icons.favorite_outline),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Enviar para quem precisa',
                icon: Icons.send_outlined,
                onPressed: _shareDevotional,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Criar cartão para compartilhar',
                icon: Icons.share_outlined,
                outlined: true,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          CardCreatorScreen(verse: devotional.verse),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _block(String title, String body, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFFD97706)),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(height: 1.6)),
        ],
      ),
    );
  }
}
