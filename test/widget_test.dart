import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cw3/main.dart';

void main() {
  testWidgets('TaskManagerApp UI Test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const TaskManagerApp());

    // Check if the "Task Manager" title is present.
    expect(find.text('Task Manager'), findsOneWidget);

    // Check if the Add button is present.
    expect(find.text('Add'), findsOneWidget);

    // Enter a task into the text field.
    await tester.enterText(find.byType(TextField), 'Test Task');

    // Tap the "Add" button.
    await tester.tap(find.text('Add'));
    await tester.pump();

    // Verify the task is added to the list.
    expect(find.text('Test Task'), findsOneWidget);
  });
}
