import 'package:farasa/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Splash screen menampilkan logo FARASA', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FarasaApp());

    expect(find.byType(Image), findsOneWidget);
  });
}
