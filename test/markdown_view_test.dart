import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_me/widgets/markdown_view.dart';

Future<void> _pump(WidgetTester tester, String src) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: MarkdownView(data: src)),
      ),
    ),
  );
}

void main() {
  testWidgets('headings and paragraphs render as text, not raw HTML', (tester) async {
    await _pump(tester, '# Hello\n\nworld');
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('world'), findsOneWidget);
    expect(find.textContaining('<h1'), findsNothing);
    expect(find.textContaining('<p>'), findsNothing);
  });

  testWidgets('inline formatting is applied without leaking markers', (tester) async {
    await _pump(tester, 'a **bold** and *it* and `code` and ~~gone~~');
    expect(find.text('a bold and it and code and gone'), findsOneWidget);
    expect(find.textContaining('**'), findsNothing);
  });

  testWidgets('unordered and ordered lists get markers', (tester) async {
    await _pump(tester, '- one\n- two\n\n1. first\n2. second');
    expect(find.text('one'), findsOneWidget);
    expect(find.text('two'), findsOneWidget);
    expect(find.text('\u2022'), findsNWidgets(2));
    expect(find.text('1.'), findsOneWidget);
    expect(find.text('2.'), findsOneWidget);
    expect(find.text('second'), findsOneWidget);
  });

  testWidgets('fenced code block keeps its content verbatim', (tester) async {
    await _pump(tester, '```\nfoo(1, 2)\nbar()\n```');
    expect(find.text('foo(1, 2)\nbar()'), findsOneWidget);
  });

  testWidgets('links render their label', (tester) async {
    await _pump(tester, 'see [the site](https://example.com) now');
    expect(find.text('see the site now'), findsOneWidget);
  });

  testWidgets('blockquote content is shown', (tester) async {
    await _pump(tester, '> quoted text');
    expect(find.text('quoted text'), findsOneWidget);
  });

  testWidgets('GFM table cells are rendered', (tester) async {
    await _pump(tester, '| h1 | h2 |\n|----|----|\n| c1 | c2 |');
    expect(find.text('h1'), findsOneWidget);
    expect(find.text('c2'), findsOneWidget);
  });

  testWidgets('Arabic text renders intact', (tester) async {
    await _pump(tester, '## عنوان\n\nهذه **ملاحظة** تجريبية');
    expect(find.text('عنوان'), findsOneWidget);
    expect(find.text('هذه ملاحظة تجريبية'), findsOneWidget);
  });

  testWidgets('empty input renders nothing and does not throw', (tester) async {
    await _pump(tester, '');
    expect(tester.takeException(), isNull);
  });
}
