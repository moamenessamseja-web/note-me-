import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

/// Renders Markdown source as native Flutter widgets (no WebView, no raw HTML).
///
/// Supported: headings, paragraphs, bold/italic/strikethrough, inline code,
/// fenced/indented code blocks, ordered/unordered/nested lists, task-list
/// checkboxes, blockquotes, horizontal rules, links (styled, not tappable:
/// the app has no url_launcher dependency), images (alt text) and GFM tables.
class MarkdownView extends StatelessWidget {
  final String data;
  final double fontSize;

  const MarkdownView({super.key, required this.data, this.fontSize = 16});

  static List<md.Node> parse(String src) {
    final doc = md.Document(extensionSet: md.ExtensionSet.gitHubFlavored);
    return doc.parseLines(src.replaceAll('\r\n', '\n').split('\n'));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontSize: fontSize,
      height: 1.6,
      color: theme.colorScheme.onSurface,
    );
    final r = _Renderer(theme, base);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: r.blocks(parse(data)),
    );
  }
}

const Set<String> _blockTags = <String>{
  'p', 'ul', 'ol', 'pre', 'blockquote', 'hr', 'table',
  'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
};

class _Renderer {
  final ThemeData theme;
  final TextStyle base;

  _Renderer(this.theme, this.base);

  Widget _gap([double h = 8]) => SizedBox(height: h);

  /// Renders a list of sibling nodes as block widgets, grouping consecutive
  /// inline nodes into a single paragraph.
  List<Widget> blocks(List<md.Node> nodes) {
    final out = <Widget>[];
    var inline = <md.Node>[];

    void flush() {
      if (inline.isEmpty) return;
      final spans = inlineSpans(inline, base);
      inline = <md.Node>[];
      final plain = spans.isEmpty;
      if (plain) return;
      out.add(Text.rich(TextSpan(children: spans, style: base)));
      out.add(_gap());
    }

    for (final n in nodes) {
      if (n is md.Element && _blockTags.contains(n.tag)) {
        flush();
        final w = block(n);
        if (w != null) {
          out.add(w);
          out.add(_gap());
        }
      } else {
        inline.add(n);
      }
    }
    flush();
    if (out.isNotEmpty) out.removeLast();
    return out;
  }

  Widget? block(md.Element e) {
    switch (e.tag) {
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        final level = int.parse(e.tag.substring(1));
        const scale = <double>[0, 1.9, 1.6, 1.35, 1.2, 1.1, 1.0];
        final style = base.copyWith(
          fontSize: (base.fontSize ?? 16) * scale[level],
          fontWeight: FontWeight.w700,
          height: 1.3,
        );
        return Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text.rich(
            TextSpan(children: inlineSpans(e.children ?? const <md.Node>[], style), style: style),
          ),
        );
      case 'p':
        return Text.rich(
          TextSpan(children: inlineSpans(e.children ?? const <md.Node>[], base), style: base),
        );
      case 'ul':
      case 'ol':
        return _list(e);
      case 'blockquote':
        return Container(
          width: double.infinity,
          padding: const EdgeInsetsDirectional.only(start: 12, top: 4, bottom: 4),
          decoration: BoxDecoration(
            border: BorderDirectional(
              start: BorderSide(color: theme.colorScheme.primary, width: 3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: blocks(e.children ?? const <md.Node>[]),
          ),
        );
      case 'pre':
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                e.textContent.replaceAll(RegExp(r'\n$'), ''),
                style: base.copyWith(
                  fontFamily: 'monospace',
                  fontSize: (base.fontSize ?? 16) * 0.9,
                  height: 1.4,
                ),
              ),
            ),
          ),
        );
      case 'hr':
        return const Divider(height: 16);
      case 'table':
        return _table(e);
    }
    return null;
  }

  Widget _list(md.Element list) {
    final ordered = list.tag == 'ol';
    var index = 1;
    final start = int.tryParse(list.attributes['start'] ?? '');
    if (start != null) index = start;
    final rows = <Widget>[];
    for (final item in list.children ?? const <md.Node>[]) {
      if (item is! md.Element || item.tag != 'li') continue;
      final kids = item.children ?? const <md.Node>[];
      final isTask = kids.isNotEmpty &&
          kids.first is md.Element &&
          (kids.first as md.Element).tag == 'input';
      final marker = isTask ? '' : (ordered ? '$index.' : '\u2022');
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: ordered ? 28 : 20,
              child: Text(marker, style: base, textAlign: TextAlign.start),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: blocks(kids),
              ),
            ),
          ],
        ),
      );
      rows.add(const SizedBox(height: 4));
      index++;
    }
    if (rows.isNotEmpty) rows.removeLast();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  Widget _table(md.Element table) {
    final rows = <List<md.Element>>[];
    final headerFlags = <bool>[];
    void collect(md.Element section, bool header) {
      for (final tr in section.children ?? const <md.Node>[]) {
        if (tr is md.Element && tr.tag == 'tr') {
          final cells = <md.Element>[
            for (final c in tr.children ?? const <md.Node>[])
              if (c is md.Element && (c.tag == 'td' || c.tag == 'th')) c,
          ];
          rows.add(cells);
          headerFlags.add(header);
        }
      }
    }

    for (final part in table.children ?? const <md.Node>[]) {
      if (part is md.Element) {
        if (part.tag == 'thead') collect(part, true);
        if (part.tag == 'tbody') collect(part, false);
      }
    }
    var cols = 0;
    for (final r in rows) {
      if (r.length > cols) cols = r.length;
    }
    if (rows.isEmpty || cols == 0) return const SizedBox.shrink();

    final tableRows = <TableRow>[];
    for (var i = 0; i < rows.length; i++) {
      final style = headerFlags[i] ? base.copyWith(fontWeight: FontWeight.w700) : base;
      final cells = <Widget>[];
      for (var c = 0; c < cols; c++) {
        if (c < rows[i].length) {
          cells.add(Padding(
            padding: const EdgeInsets.all(6),
            child: Text.rich(TextSpan(
              children: inlineSpans(rows[i][c].children ?? const <md.Node>[], style),
              style: style,
            )),
          ));
        } else {
          cells.add(const SizedBox.shrink());
        }
      }
      tableRows.add(TableRow(
        decoration: headerFlags[i]
            ? BoxDecoration(color: theme.colorScheme.surfaceContainerHighest)
            : null,
        children: cells,
      ));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        border: TableBorder.all(color: theme.dividerColor),
        children: tableRows,
      ),
    );
  }

  List<InlineSpan> inlineSpans(List<md.Node> nodes, TextStyle style) {
    final out = <InlineSpan>[];
    for (final n in nodes) {
      if (n is md.Text) {
        out.add(TextSpan(text: n.text, style: style));
      } else if (n is md.Element) {
        switch (n.tag) {
          case 'strong':
            out.addAll(inlineSpans(
                n.children ?? const <md.Node>[], style.copyWith(fontWeight: FontWeight.w700)));
            break;
          case 'em':
            out.addAll(inlineSpans(
                n.children ?? const <md.Node>[], style.copyWith(fontStyle: FontStyle.italic)));
            break;
          case 'del':
            out.addAll(inlineSpans(n.children ?? const <md.Node>[],
                style.copyWith(decoration: TextDecoration.lineThrough)));
            break;
          case 'code':
            out.add(TextSpan(
              text: n.textContent,
              style: style.copyWith(
                fontFamily: 'monospace',
                fontSize: (style.fontSize ?? 16) * 0.9,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ));
            break;
          case 'a':
            out.addAll(inlineSpans(
              n.children ?? const <md.Node>[],
              style.copyWith(
                color: theme.colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ));
            break;
          case 'img':
            final alt = n.attributes['alt'] ?? '';
            out.add(TextSpan(text: alt.isEmpty ? '[image]' : '[image: $alt]', style: style));
            break;
          case 'br':
            out.add(TextSpan(text: '\n', style: style));
            break;
          case 'input':
            final checked = n.attributes.containsKey('checked');
            out.add(TextSpan(text: checked ? '\u2611 ' : '\u2610 ', style: style));
            break;
          default:
            out.addAll(inlineSpans(n.children ?? const <md.Node>[], style));
        }
      }
    }
    return out;
  }
}
