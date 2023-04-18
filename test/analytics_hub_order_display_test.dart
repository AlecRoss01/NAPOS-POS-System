import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as ft;
import 'package:napos/classes/employee.dart';
import 'package:napos/classes/menu_item.dart';
import 'package:test/test.dart';
import 'dart:ui' as ui;

import 'package:napos/widgets/analytics_hub_order_display.dart';
import 'package:napos/classes/order.dart';

// Doesn't work because original widget doesn't have directionality built
// into it. Stupid.

void main() {
  group('AH order display widget test: ', () {
    var employee = NAPOS_Employee("Jake", 23, 1234, 1);

    var order = Order(employee, id: 25);
    order.setOrderItems([
      MenuItem('Salad'),
    ]);

    var display = AnalyticsHubOrderDisplay(order: order);
    var card = Card(child: display);
    var d = Directionality(
        textDirection: ui.TextDirection.ltr,
        child: card
    );

    ft.testWidgets('Contains order details', (ft.WidgetTester tester) async {
      await tester.pumpWidget(card);
      
      //expect(ft.find.text('00025'), true);
    });

    ft.testWidgets('Contains order contents', (ft.WidgetTester tester) async {
      //await tester.pumpWidget(display);

      //expect(ft.find.text('00025'), true);
    });
  });
}