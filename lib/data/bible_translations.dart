import 'package:flutter/material.dart';

/// 지원하는 성경 역본 코드와 표시 이름.
const Map<String, String> bibleTranslationNames = {
  'korean': '개역개정',
  'korean2': '쉬운성경',
  'korean3': '새번역',
  'niv': 'NIV',
};

/// 역본별 구분용 파스텔 색상 (선택 시 배경색으로 사용).
const Map<String, Color> bibleTranslationColors = {
  'korean': Color(0xFFB5EAD7),
  'korean2': Color(0xFFFFDAC1),
  'korean3': Color(0xFFC7CEEA),
  'niv': Color(0xFFFFB7B2),
};
