import 'package:flutter/material.dart';
import 'package:versos_diarios/models/verse.dart';

/// Seletor horizontal de temas/sentimentos.
class ThemeSelector extends StatelessWidget {
  final VerseTheme? selected;
  final ValueChanged<VerseTheme> onSelected;

  const ThemeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const Map<VerseTheme, IconData> _icons = {
    VerseTheme.ansiedade: Icons.self_improvement,
    VerseTheme.paz: Icons.water_drop_outlined,
    VerseTheme.gratidao: Icons.favorite_outline,
    VerseTheme.esperanca: Icons.wb_sunny_outlined,
    VerseTheme.direcao: Icons.explore_outlined,
    VerseTheme.familia: Icons.home_outlined,
    VerseTheme.forca: Icons.fitness_center_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        itemCount: VerseTheme.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final theme = VerseTheme.values[index];
          final isSelected = theme == selected;
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onSelected(theme),
            child: Container(
              width: 96,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1E3A8A)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1E3A8A)
                      : colorScheme.outline.withValues(alpha: 0.3),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(
                            0xFF1E3A8A,
                          ).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _icons[theme],
                    color: isSelected
                        ? const Color(0xFFFBBF24)
                        : const Color(0xFF1E3A8A),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    theme.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF1E3A8A),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
