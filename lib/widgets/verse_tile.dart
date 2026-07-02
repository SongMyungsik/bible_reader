import 'package:flutter/material.dart';

import '../models/verse.dart';

class VerseTile extends StatelessWidget {
  final Verse verse;
  final String text;
  final bool isBookmarked;
  final VoidCallback onToggleBookmark;
  final VoidCallback? onTap;
  final bool showReference;

  const VerseTile({
    super.key,
    required this.verse,
    required this.text,
    required this.isBookmarked,
    required this.onToggleBookmark,
    this.onTap,
    this.showReference = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.only(left: 4, right: 4),
      horizontalTitleGap: 4,
      title: Text(
        showReference ? verse.reference : '${verse.verse}. $text',
        style: TextStyle(
          fontSize: 16,
          height: 1.4,
          fontWeight: FontWeight.bold,
          color: isBookmarked ? Colors.amber : null,
        ),
      ),
      subtitle: showReference ? Text(text) : null,
      trailing: IconButton(
        icon: Icon(
          isBookmarked ? Icons.star : Icons.star_border,
          color: isBookmarked ? Colors.amber : Colors.grey,
        ),
        iconSize: 20,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        visualDensity: VisualDensity.compact,
        onPressed: onToggleBookmark,
      ),
    );
  }
}
