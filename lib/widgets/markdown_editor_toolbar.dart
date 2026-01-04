import 'package:flutter/material.dart';

class MarkdownEditorToolbar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPreview;

  const MarkdownEditorToolbar({
    super.key,
    required this.controller,
    required this.onPreview,
  });

  void _insertMarkdown(String before, [String after = '']) {
    final text = controller.text;
    final selection = controller.selection;
    
    if (selection.baseOffset == -1) {
      controller.text = text + before + after;
      return;
    }

    final selectedText = text.substring(selection.baseOffset, selection.extentOffset);
    final newText = text.replaceRange(
      selection.baseOffset,
      selection.extentOffset,
      '$before$selectedText$after',
    );
    
    controller.text = newText;
    
    // 移动光标
    Future.delayed(const Duration(milliseconds: 10), () {
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: selection.baseOffset + before.length + selectedText.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ToolButton(
              icon: Icons.title,
              tooltip: '标题',
              onPressed: () => _insertMarkdown('# ', '\n'),
            ),
            _ToolButton(
              icon: Icons.format_bold,
              tooltip: '加粗',
              onPressed: () => _insertMarkdown('**', '**'),
            ),
            _ToolButton(
              icon: Icons.format_italic,
              tooltip: '斜体',
              onPressed: () => _insertMarkdown('*', '*'),
            ),
            _ToolButton(
              icon: Icons.text_fields,
              tooltip: '删除线',
              onPressed: () => _insertMarkdown('~~', '~~'),
            ),
            const SizedBox(width: 8),
            _ToolButton(
              icon: Icons.list,
              tooltip: '无序列表',
              onPressed: () => _insertMarkdown('- ', '\n'),
            ),
            _ToolButton(
              icon: Icons.format_list_numbered,
              tooltip: '有序列表',
              onPressed: () => _insertMarkdown('1. ', '\n'),
            ),
            const SizedBox(width: 8),
            _ToolButton(
              icon: Icons.code,
              tooltip: '行内代码',
              onPressed: () => _insertMarkdown('`', '`'),
            ),
            _ToolButton(
              icon: Icons.article,
              tooltip: '代码块',
              onPressed: () => _insertMarkdown('```\n', '\n```\n'),
            ),
            const SizedBox(width: 8),
            _ToolButton(
              icon: Icons.format_quote,
              tooltip: '引用',
              onPressed: () => _insertMarkdown('> ', '\n'),
            ),
            _ToolButton(
              icon: Icons.image,
              tooltip: '图片链接',
              onPressed: () => _insertMarkdown('![alt](', ')'),
            ),
            _ToolButton(
              icon: Icons.link,
              tooltip: '链接',
              onPressed: () => _insertMarkdown('[', '](url)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _ToolButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 20, color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
