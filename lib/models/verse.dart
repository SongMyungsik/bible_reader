class Verse {
  final String book;
  final int chapter;
  final int verse;
  final Map<String, String> texts;

  const Verse({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.texts,
  });

  static String _textField(Map<String, dynamic> json, String key) {
    final value = json[key];
    return value is String ? value : '';
  }

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      book: json['book'] as String,
      chapter: json['chapter'] as int,
      verse: json['verse'] as int,
      texts: {
        'korean': _textField(json, 'korean'),
        'korean2': _textField(json, 'korean2'),
        'korean3': _textField(json, 'korean3'),
        'niv': _textField(json, 'niv'),
      },
    );
  }

  String textFor(String translation) => texts[translation] ?? '';

  /// 북마크 저장용 고유 키 (예: "요한복음 3:16")
  String get reference => '$book $chapter:$verse';
}
