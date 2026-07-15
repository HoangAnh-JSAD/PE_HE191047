import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_manager_exam_standard/main.dart';

void main() {
  testWidgets('App load test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: UserManagerApp()));
    expect(find.text('User Manager'), findsWidgets);
  });
}
