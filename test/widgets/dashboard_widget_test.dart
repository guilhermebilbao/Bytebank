import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../matchers/matchers.dart';

void main() {
  testWidgets('Should display the main image when the Dashboard is opened',
          (WidgetTester tester) async {
        // é diferente a abordagem pois usa um callback na chamada
        await tester.pumpWidget(MaterialApp(home: DashboardContainer()));
        // teve que colocar a dependencia (nesse caso o MaterialApp) para que a montagem do widget funcione
        final mainImage = find.byType(Image);
        // procurando por uma imagem no dashboard (mainImage) para garantir que a imagem apareceu no app
        expect(mainImage, findsOneWidget);
      });

  testWidgets(
      'Should display the transfer feature when the Dashboard is opened', (
      tester) async {
    await tester.pumpWidget(MaterialApp(home: DashboardContainer()));
    // final iconTransferFeatureItem = find.widgetWithIcon(FeatureItem, Icons.monetization_on);
    // expect(iconTransferFeatureItem, findsOneWidget);
    // final nameTransferFeatureItem = find.widgetWithText(FeatureItem, 'Transfer');
    // expect(nameTransferFeatureItem, findsOneWidget);
    final transferFeatureItem = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transfer', Icons.monetization_on));
        expect(transferFeatureItem, findsOneWidget);
  });

  testWidgets(
      'Should display the transaction feed feature when the Dashboard is opened', (
      tester) async {
    await tester.pumpWidget(MaterialApp(home: DashboardContainer()));
    final transactionFeedFeatureItem = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transaction Feed', Icons.description));
        expect(transactionFeedFeatureItem, findsOneWidget);
  });
}


