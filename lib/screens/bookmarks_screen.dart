import 'package:flutter/material.dart';

import '../data/bible_repository.dart';
import '../models/verse.dart';
import '../widgets/verse_tile.dart';

class BookmarksScreen extends StatelessWidget {
  final BibleRepository repository;
  final String selectedTranslation;
  final Set<String> bookmarkedRefs;
  final ValueChanged<Verse> onToggleBookmark;
  final ValueChanged<Verse> onSelectVerse;

  const BookmarksScreen({
    super.key,
    required this.repository,
    required this.selectedTranslation,
    required this.bookmarkedRefs,
    required this.onToggleBookmark,
    required this.onSelectVerse,
  });

  @override
  Widget build(BuildContext context) {
    final bookmarked = repository.versesByReferences(bookmarkedRefs);

    if (bookmarked.isEmpty) {
      return const Center(child: Text('북마크한 절이 없습니다'));
    }

    return ListView.builder(
      itemCount: bookmarked.length,
      itemBuilder: (context, idx) {
        final verse = bookmarked[idx];
        return VerseTile(
          verse: verse,
          text: verse.textFor(selectedTranslation),
          showReference: true,
          isBookmarked: true,
          onToggleBookmark: () => onToggleBookmark(verse),
          onTap: () => onSelectVerse(verse),
        );
      },
    );
  }
}
