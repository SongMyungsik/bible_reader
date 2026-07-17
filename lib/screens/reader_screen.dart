import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/bible_books.dart';
import '../data/bible_repository.dart';
import '../data/bible_translations.dart';
import '../models/verse.dart';
import '../widgets/verse_tile.dart';

class ReaderScreen extends StatelessWidget {
  final BibleRepository repository;
  final List<String> bookNames;
  final String selectedBook;
  final int selectedChapter;
  final String selectedTranslation;
  final Set<String> bookmarkedRefs;
  final ValueChanged<String> onBookChanged;
  final ValueChanged<int> onChapterChanged;
  final ValueChanged<String> onTranslationChanged;
  final ValueChanged<Verse> onToggleBookmark;
  final VoidCallback onPrevChapter;
  final VoidCallback onNextChapter;
  final double fontSize;

  const ReaderScreen({
    super.key,
    required this.repository,
    required this.bookNames,
    required this.selectedBook,
    required this.selectedChapter,
    required this.selectedTranslation,
    required this.bookmarkedRefs,
    required this.onBookChanged,
    required this.onChapterChanged,
    required this.onTranslationChanged,
    required this.onToggleBookmark,
    required this.onPrevChapter,
    required this.onNextChapter,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final verses = repository.versesFor(selectedBook, selectedChapter);
    final chapterCount = bibleBookChapterCounts[selectedBook] ?? 1;

    return Stack(
      children: [
        _buildContent(verses, chapterCount),
        Positioned(
          left: 16,
          bottom: 16,
          child: _ChapterNavButton(
            icon: Icons.play_arrow,
            rotate: true,
            tooltip: '이전 장',
            onPressed: onPrevChapter,
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: _ChapterNavButton(
            icon: Icons.play_arrow,
            rotate: false,
            tooltip: '다음 장',
            onPressed: onNextChapter,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(List<Verse> verses, int chapterCount) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  key: ValueKey(selectedBook),
                  initialValue: selectedBook,
                  isExpanded: true,
                  items: bookNames
                      .map(
                        (b) => DropdownMenuItem(value: b, child: Text(b)),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) onBookChanged(v);
                  },
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<int>(
                  key: ValueKey('$selectedBook-$selectedChapter'),
                  initialValue: selectedChapter,
                  items: List.generate(chapterCount, (i) => i + 1)
                      .map(
                        (c) => DropdownMenuItem(value: c, child: Text('$c장')),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) onChapterChanged(v);
                  },
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Row(
            children: bibleTranslationNames.entries.map((entry) {
              final selected = selectedTranslation == entry.key;
              final color = bibleTranslationColors[entry.key]!;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTranslationChanged(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 2,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? color : const Color(0xFF243144),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selected ? color : Colors.white24,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (selected) ...[
                          const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.black87,
                          ),
                          const SizedBox(width: 3),
                        ],
                        Flexible(
                          child: Text(
                            entry.value,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color:
                                  selected ? Colors.black87 : Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: verses.isEmpty
              ? const Center(child: Text('본문 데이터가 없습니다'))
              : ListView.builder(
                  key: ValueKey('$selectedBook-$selectedChapter'),
                  itemCount: verses.length,
                  itemBuilder: (context, idx) {
                    final verse = verses[idx];
                    return VerseTile(
                      verse: verse,
                      text: verse.textFor(selectedTranslation),
                      isBookmarked: bookmarkedRefs.contains(verse.reference),
                      onToggleBookmark: () => onToggleBookmark(verse),
                      fontSize: fontSize,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ChapterNavButton extends StatelessWidget {
  final IconData icon;
  final bool rotate;
  final String tooltip;
  final VoidCallback onPressed;

  const _ChapterNavButton({
    required this.icon,
    required this.rotate,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: const Color(0xFF243144).withValues(alpha: 0.85),
        shape: const CircleBorder(),
        elevation: 4,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Transform.rotate(
              angle: rotate ? math.pi : 0,
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}
