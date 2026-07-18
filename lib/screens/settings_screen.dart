import 'package:flutter/material.dart';

import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  final AppSettings settings;

  const SettingsScreen({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        const _SectionTitle('테마'),
        const SizedBox(height: 12),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(
              value: ThemeMode.system,
              label: Text('시스템'),
              icon: Icon(Icons.brightness_auto),
            ),
            ButtonSegment(
              value: ThemeMode.light,
              label: Text('라이트'),
              icon: Icon(Icons.light_mode),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              label: Text('다크'),
              icon: Icon(Icons.dark_mode),
            ),
          ],
          selected: {settings.themeMode},
          onSelectionChanged: (selection) =>
              settings.setThemeMode(selection.first),
        ),
        const SizedBox(height: 32),
        const _SectionTitle('메인 색상'),
        const SizedBox(height: 4),
        const Text(
          '앱바와 하단 탭 메뉴의 색상을 바꿉니다.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(accentColorOptions.length, (i) {
            final color = accentColorOptions[i];
            final selected = settings.accentIndex == i;
            final onColor =
                ThemeData.estimateBrightnessForColor(color) == Brightness.dark
                ? Colors.white
                : Colors.black87;
            return GestureDetector(
              onTap: () => settings.setAccentIndex(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: selected
                    ? Icon(Icons.check, color: onColor, size: 20)
                    : null,
              ),
            );
          }),
        ),
        const SizedBox(height: 32),
        const _SectionTitle('글씨 크기'),
        const SizedBox(height: 4),
        const Text(
          '성경 본문의 글씨 크기를 조절합니다.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        _FontSizeSelector(settings: settings),
        const SizedBox(height: 32),
        const _SectionTitle('앱 사용법'),
        const SizedBox(height: 12),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '절 오른쪽의 별표는 무엇인가요?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '각 절 오른쪽의 별표를 누르면 그 절이 북마크에 추가돼요. 북마크한 절은 '
                        '노란 별과 굵은 글씨로 표시되고, 하단의 "북마크" 탭에서 모아볼 수 있어요. '
                        '별표를 다시 누르면 북마크가 해제됩니다.',
                        style: TextStyle(height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class _FontSizeSelector extends StatelessWidget {
  final AppSettings settings;

  const _FontSizeSelector({required this.settings});

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final count = verseFontSizes.length;

    return Row(
      children: [
        const Text('가', style: TextStyle(fontSize: 12)),
        Expanded(
          child: SizedBox(
            height: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(height: 2, color: Theme.of(context).dividerColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(count, (i) {
                    final selected = settings.fontSizeIndex == i;
                    final dotSize = 12.0 + i * 4;
                    return GestureDetector(
                      onTap: () => settings.setFontSizeIndex(i),
                      child: Container(
                        width: 36,
                        height: 44,
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Container(
                          width: selected ? dotSize + 8 : dotSize,
                          height: selected ? dotSize + 8 : dotSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? accent
                                : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                            border: Border.all(
                              color: accent,
                              width: selected ? 0 : 1.5,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        const Text('가', style: TextStyle(fontSize: 28)),
      ],
    );
  }
}
