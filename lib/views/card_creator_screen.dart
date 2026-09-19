import 'package:flutter/material.dart';
import 'package:versos_diarios/models/verse.dart';
import 'package:versos_diarios/widgets/app_button.dart';
import 'package:versos_diarios/widgets/section_title.dart';

/// Tela para montar um cartão compartilhável do versículo.
class CardCreatorScreen extends StatefulWidget {
  final Verse verse;

  const CardCreatorScreen({super.key, required this.verse});

  static const routeName = '/card-creator';

  @override
  State<CardCreatorScreen> createState() => _CardCreatorScreenState();
}

class _CardCreatorScreenState extends State<CardCreatorScreen> {
  int _backgroundIndex = 0;

  static const List<List<Color>> _backgrounds = [
    [Color(0xFF1E3A8A), Color(0xFF3B5BB5)],
    [Color(0xFF0F766E), Color(0xFF14B8A6)],
    [Color(0xFF7C2D12), Color(0xFFD97706)],
    [Color(0xFF4C1D95), Color(0xFF8B5CF6)],
  ];

  @override
  Widget build(BuildContext context) {
    final bg = _backgrounds[_backgroundIndex % _backgrounds.length];
    return Scaffold(
      appBar: AppBar(title: const Text('Criar cartão')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: 'Pré-visualização',
              subtitle: 'Escolha um fundo e compartilhe sua fé',
            ),
            const SizedBox(height: 12),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: bg,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: bg.first.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.format_quote,
                      color: Colors.white70,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.verse.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '— ${widget.verse.reference}',
                      style: const TextStyle(
                        color: Color(0xFFFDE68A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Versos Diários',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Fundo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(_backgrounds.length, (index) {
                final colors = _backgrounds[index];
                final selected = index == _backgroundIndex;
                return GestureDetector(
                  onTap: () => setState(() => _backgroundIndex = index),
                  child: Container(
                    width: 56,
                    height: 56,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: colors),
                      borderRadius: BorderRadius.circular(14),
                      border: selected
                          ? Border.all(color: const Color(0xFFD97706), width: 3)
                          : null,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Compartilhar (em breve)',
                icon: Icons.share_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'O compartilhamento com imagem chegará na próxima etapa (share_plus + screenshot).',
                      ),
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
}
