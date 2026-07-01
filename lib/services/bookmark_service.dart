import 'package:shared_preferences/shared_preferences.dart';

import '../models/verse.dart';

class BookmarkService {
  static const _prefsKey = 'bookmarked_verse_refs';

  Future<Set<String>> loadRefs() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_prefsKey) ?? []).toSet();
  }

  Future<void> _saveRefs(Set<String> refs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, refs.toList());
  }

  Future<Set<String>> toggle(Verse verse) async {
    final refs = await loadRefs();
    if (!refs.remove(verse.reference)) {
      refs.add(verse.reference);
    }
    await _saveRefs(refs);
    return refs;
  }

  Future<Set<String>> remove(Verse verse) async {
    final refs = await loadRefs();
    refs.remove(verse.reference);
    await _saveRefs(refs);
    return refs;
  }
}
