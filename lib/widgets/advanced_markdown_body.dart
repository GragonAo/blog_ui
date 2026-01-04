import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class AdvancedMarkdownBody extends StatelessWidget {
  final String data;

  const AdvancedMarkdownBody({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
        h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
        h2: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.4),
        h3: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4),
        code: TextStyle(
          backgroundColor: Colors.grey.shade100,
          color: Colors.pink.shade700,
          fontFamily: 'monospace',
          fontSize: 14,
        ),
        codeblockDecoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8),
        ),
        blockquote: TextStyle(
          color: Colors.grey.shade700,
          fontStyle: FontStyle.italic,
        ),
        blockquotePadding: const EdgeInsets.all(12),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.grey.shade400, width: 4),
          ),
          color: Colors.grey.shade50,
        ),
        listBullet: const TextStyle(fontSize: 15, height: 1.6),
      ),
      extensionSet: md.ExtensionSet.gitHubFlavored,
    );
  }
}
