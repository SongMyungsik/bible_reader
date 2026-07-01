import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/verse.dart';

class BibleRepository {
  List<Verse> _verses = [];

  List<Verse> get verses => _verses;

  Future<void> load() async {
    final raw = await rootBundle.loadString('assets/bible.json');
    final decoded = json.decode(raw) as List;
    _verses = decoded
        .map((e) => Verse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<Verse> versesFor(String book, int chapter) {
    return _verses
        .where((v) => v.book == book && v.chapter == chapter)
        .toList();
  }

  List<Verse> search(String query, String translation) {
    final q = query.trim();
    if (q.isEmpty) return [];
    return _verses.where((v) => v.textFor(translation).contains(q)).toList();
  }

  List<Verse> versesByReferences(Iterable<String> refs) {
    final refSet = refs.toSet();
    return _verses.where((v) => refSet.contains(v.reference)).toList();
  }
}
