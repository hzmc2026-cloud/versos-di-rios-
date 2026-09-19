import 'package:flutter/material.dart';
import 'package:versos_diarios/models/verse.dart';
import 'package:versos_diarios/utils/share_helper.dart';

/// Cartão reutilizável que exibe um versículo.
class VerseCard extends StatelessWidget {
  final Verse verse;
  final VoidCallback? onTap;
  final bool showTheme;
  final bool showShareButton;
  final String? reflection;

  const VerseCard({
    super.key,
    required this.verse,
    this.onTap,
    this.showTheme = true,
    this.showShareButton = false,
    this.reflection,
  });

  /// Compartilha este versículo ("Enviar para alguém que precisa").
  Future<void> shareVerse() {
    return ShareHelper.shareVerse(verse, reflection: reflection);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showTheme)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    verse.theme.label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: const Color(0xFFD97706),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (showTheme) const SizedBox(height: 12),
              Text(
                '"${verse.text}"',
                style: theme.textTheme.titleMedium?.copyWith(
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '— ${verse.reference}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF1E3A8A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (showShareButton) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: shareVerse,
                    icon: const Icon(
                      Icons.send_outlined,
                      size: 18,
                    ),
                    label: const Text('Enviar para alguém que precisa'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
