import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bible_reader/main.dart';

void main() {
  testWidgets('앱이 시작되면 성경 뷰어 하단 탭 3개가 보인다', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const BibleReaderApp());
    // 로딩 스피너가 무한 애니메이션이라 pumpAndSettle은 타임아웃되므로
    // 데이터 로드가 끝날 만큼만 명시적으로 pump한다.
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('읽기'), findsOneWidget);
    expect(find.text('검색'), findsOneWidget);
    expect(find.text('북마크'), findsOneWidget);
  });
}
