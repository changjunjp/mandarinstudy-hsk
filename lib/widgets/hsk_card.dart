import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/hsk_item.dart';

class HskCard extends StatefulWidget {
  final HskItem item;
  final bool showDetails;

  const HskCard({
    super.key,
    required this.item,
    this.showDetails = false,
  });

  @override
  State<HskCard> createState() => _HskCardState();
}

class _HskCardState extends State<HskCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isExpanded = widget.showDetails || _expanded;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Chinese text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.chinese,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.pinyin,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Type badge
                  Chip(
                    label: Text(
                      item.isWord ? '単語' : '例文',
                      style: const TextStyle(fontSize: 11),
                    ),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: item.isWord
                        ? colorScheme.primaryContainer
                        : colorScheme.secondaryContainer,
                  ),
                ],
              ),
              // Image (if available)
              if (item.imageSrc != null && item.imageSrc!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: item.imageSrc!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 120,
                        color: colorScheme.surfaceContainerHighest,
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 120,
                        color: colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                ),
              // Expanded details
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      _detailRow('English', item.english, Icons.language),
                      _detailRow('日本語', item.japanese, Icons.translate),
                      if (item.imageHint != null && item.imageHint!.isNotEmpty)
                        _detailRow('HINT', item.imageHint!, Icons.help_outline),
                      if (item.relatedWords.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Wrap(
                            spacing: 4,
                            children: item.relatedWords.map((id) => Chip(
                              label: Text(id.substring(0, 6), style: const TextStyle(fontSize: 10)),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            )).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
            fontSize: 13,
          )),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
