import 'package:flutter/material.dart';

import 'data/bible_books.dart';
import 'data/bible_repository.dart';
import 'models/verse.dart';
import 'screens/bookmarks_screen.dart';
import 'screens/reader_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/start_screen.dart';
import 'services/bookmark_service.dart';
import 'services/settings_service.dart';

void main() {
  runApp(const BibleReaderApp());
}

class BibleReaderApp extends StatefulWidget {
  const BibleReaderApp({super.key});

  @override
  State<BibleReaderApp> createState() => _BibleReaderAppState();
}

class _BibleReaderAppState extends State<BibleReaderApp> {
  final _settings = AppSettings();

  @override
  void initState() {
    super.initState();
    _settings.load();
  }

  @override
  void dispose() {
    _settings.dispose();
    super.dispose();
  }

  ThemeData _buildTheme(Brightness brightness, Color accent) {
    final isDark = brightness == Brightness.dark;
    final onAccent =
        ThemeData.estimateBrightnessForColor(accent) == Brightness.dark
            ? Colors.white
            : Colors.black87;
    return ThemeData(
      colorSchemeSeed: accent,
      brightness: brightness,
      useMaterial3: true,
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF0F1923) : const Color(0xFFF7F7F2),
      appBarTheme: AppBarTheme(
        backgroundColor: accent,
        foregroundColor: onAccent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor:
            isDark ? const Color(0xFF243144) : const Color(0xFFE9EEF2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: accent,
        selectedItemColor: onAccent,
        unselectedItemColor: onAccent.withValues(alpha: 0.6),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settings,
      builder: (context, _) {
        return MaterialApp(
          title: '성경 뷰어',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(Brightness.light, _settings.accentColor),
          darkTheme: _buildTheme(Brightness.dark, _settings.accentColor),
          themeMode: _settings.themeMode,
          home: RootPage(settings: _settings),
        );
      },
    );
  }
}

class RootPage extends StatefulWidget {
  final AppSettings settings;

  const RootPage({super.key, required this.settings});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final _repository = BibleRepository();
  final _bookmarkService = BookmarkService();

  bool _isLoading = true;
  bool _started = false;
  int _selectedIndex = 0;

  String _selectedBook = bibleBookNames.first;
  int _selectedChapter = 1;
  String _selectedTranslation = 'korean';
  Set<String> _bookmarkedRefs = {};
  bool _isOldTestament = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _repository.load();
    final refs = await _bookmarkService.loadRefs();
    setState(() {
      _bookmarkedRefs = refs;
      _isLoading = false;
    });
  }

  Future<void> _toggleBookmark(Verse verse) async {
    final refs = await _bookmarkService.toggle(verse);
    setState(() => _bookmarkedRefs = refs);
  }

  void _goToVerse(Verse verse) {
    setState(() {
      _selectedBook = verse.book;
      _selectedChapter = verse.chapter;
      _selectedIndex = 0;
      _isOldTestament = isOldTestamentBook(verse.book);
    });
  }

  void _stepChapter(int delta) {
    setState(() {
      final bookIndex = bibleBookNames.indexOf(_selectedBook);
      final chapterCount = bibleBookChapterCounts[_selectedBook] ?? 1;
      final newChapter = _selectedChapter + delta;
      if (newChapter >= 1 && newChapter <= chapterCount) {
        _selectedChapter = newChapter;
      } else if (newChapter > chapterCount &&
          bookIndex < bibleBookNames.length - 1) {
        _selectedBook = bibleBookNames[bookIndex + 1];
        _selectedChapter = 1;
      } else if (newChapter < 1 && bookIndex > 0) {
        _selectedBook = bibleBookNames[bookIndex - 1];
        _selectedChapter = bibleBookChapterCounts[_selectedBook] ?? 1;
      }
      _isOldTestament = isOldTestamentBook(_selectedBook);
    });
  }

  void _onTestamentChanged(bool isOld) {
    setState(() {
      _isOldTestament = isOld;
      final books = isOld ? bibleOldTestamentBooks : bibleNewTestamentBooks;
      if (!books.contains(_selectedBook)) {
        _selectedBook = books.first;
        _selectedChapter = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) {
      return StartScreen(onStart: () => setState(() => _started = true));
    }

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screens = [
      ReaderScreen(
        repository: _repository,
        bookNames: _isOldTestament ? bibleOldTestamentBooks : bibleNewTestamentBooks,
        selectedBook: _selectedBook,
        selectedChapter: _selectedChapter,
        selectedTranslation: _selectedTranslation,
        bookmarkedRefs: _bookmarkedRefs,
        onBookChanged: (book) => setState(() {
          _selectedBook = book;
          _selectedChapter = 1;
        }),
        onChapterChanged: (chapter) =>
            setState(() => _selectedChapter = chapter),
        onTranslationChanged: (translation) =>
            setState(() => _selectedTranslation = translation),
        onToggleBookmark: _toggleBookmark,
        onPrevChapter: () => _stepChapter(-1),
        onNextChapter: () => _stepChapter(1),
        fontSize: widget.settings.verseFontSize,
      ),
      SearchScreen(
        repository: _repository,
        selectedTranslation: _selectedTranslation,
        bookmarkedRefs: _bookmarkedRefs,
        onToggleBookmark: _toggleBookmark,
        onSelectVerse: _goToVerse,
        fontSize: widget.settings.verseFontSize,
      ),
      BookmarksScreen(
        repository: _repository,
        selectedTranslation: _selectedTranslation,
        bookmarkedRefs: _bookmarkedRefs,
        onToggleBookmark: _toggleBookmark,
        onSelectVerse: _goToVerse,
        fontSize: widget.settings.verseFontSize,
      ),
      SettingsScreen(settings: widget.settings),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('[나의 성경]'),
        actions: _selectedIndex == 3
            ? null
            : [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: true, label: Text('구약')),
                      ButtonSegment(value: false, label: Text('신약')),
                    ],
                    selected: {_isOldTestament},
                    onSelectionChanged: (selection) =>
                        _onTestamentChanged(selection.first),
                  ),
                ),
              ],
      ),
      body: SafeArea(child: screens[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: '읽기'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: '북마크'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}
