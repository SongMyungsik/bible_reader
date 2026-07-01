import 'package:flutter/material.dart';

import '../data/bible_repository.dart';
import '../models/verse.dart';
import '../widgets/verse_tile.dart';

class SearchScreen extends StatefulWidget {
  final BibleRepository repository;
  final String selectedTranslation;
  final Set<String> bookmarkedRefs;
  final ValueChanged<Verse> onToggleBookmark;
  final ValueChanged<Verse> onSelectVerse;

  const SearchScreen({
    super.key,
    required this.repository,
    required this.selectedTranslation,
    required this.bookmarkedRefs,
    required this.onToggleBookmark,
    required this.onSelectVerse,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<Verse> _results = [];

  @override
  void didUpdateWidget(covariant SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTranslation != widget.selectedTranslation) {
      _runSearch(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runSearch(String query) {
    setState(() {
      _results = widget.repository.search(query, widget.selectedTranslation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _controller,
            onChanged: _runSearch,
            decoration: const InputDecoration(
              labelText: '검색어 입력',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _controller.text.isEmpty
              ? const Center(child: Text('검색어를 입력하세요'))
              : _results.isEmpty
                  ? const Center(child: Text('검색 결과가 없습니다'))
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, idx) {
                        final verse = _results[idx];
                        return VerseTile(
                          verse: verse,
                          text: verse.textFor(widget.selectedTranslation),
                          showReference: true,
                          isBookmarked:
                              widget.bookmarkedRefs.contains(verse.reference),
                          onToggleBookmark: () =>
                              widget.onToggleBookmark(verse),
                          onTap: () => widget.onSelectVerse(verse),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
