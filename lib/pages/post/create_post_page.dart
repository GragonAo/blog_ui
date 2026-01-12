import 'package:blog_ui/models/post/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../widgets/markdown_editor_toolbar.dart';

class CreatePostPage extends StatefulWidget {
  final Post? post;

  const CreatePostPage({super.key, this.post});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _contentController;
  late TextEditingController _tagController;

  String _selectedTag = '技术灵感';
  bool _showPreview = false;
  String _selectedImage = 'https://images.unsplash.com/photo-1523475472560-d2df97ec485c?auto=format&fit=crop&w=900&q=80';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _descriptionController = TextEditingController(text: widget.post?.summary ?? '');
    _contentController = TextEditingController(text: widget.post?.content ?? '');
    _tagController = TextEditingController(text: _selectedTag);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _publishPost() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入文章标题')),
      );
      return;
    }

    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入文章内容')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('文章发布成功！')),
    );

    // 延迟后返回
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) Navigator.pop(context);
    });
  }

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('草稿已保存')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.post != null ? '编辑文章' : '发布文章',
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton.icon(
            onPressed: _saveDraft,
            icon: const Icon(LucideIcons.save, size: 18),
            label: const Text('保存草稿'),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton.icon(
              onPressed: _publishPost,
              icon: const Icon(LucideIcons.send, size: 18),
              label: const Text('发布'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _showPreview ? _buildPreviewMode() : _buildEditMode(),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.redAccent,
        onPressed: () {
          setState(() {
            _showPreview = !_showPreview;
          });
        },
        child: Icon(_showPreview ? LucideIcons.edit : LucideIcons.eye),
      ),
    );
  }

  Widget _buildEditMode() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 文章标题
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('文章标题', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: '请输入文章标题（必填）',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    maxLines: null,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 文章描述
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('文章描述', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: '简短描述或摘要（可选）',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 分类和标签
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('分类和标签', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['技术灵感', '旅行日记', '生活感悟', '编程技巧', '设计分享'].map((tag) {
                      final isSelected = tag == _selectedTag;
                      return FilterChip(
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedTag = tag;
                            _tagController.text = tag;
                          });
                        },
                        label: Text(tag),
                        backgroundColor: Colors.grey[100],
                        selectedColor: Colors.redAccent.withOpacity(0.15),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.redAccent : Colors.black87,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Markdown 编辑器
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('文章内容 (Markdown)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      const Spacer(),
                      Tooltip(
                        message: '支持 Markdown 语法',
                        child: Icon(LucideIcons.helpCircle, size: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildMarkdownTips(),
                  const SizedBox(height: 12),
                  // Markdown 工具栏
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border.all(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: MarkdownEditorToolbar(
                      controller: _contentController,
                      onPreview: () {
                        setState(() {
                          _showPreview = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      hintText: '# 标题\n\n## 副标题\n\n输入你的内容...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    maxLines: 15,
                    style: const TextStyle(fontFamily: 'Courier', fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkdownTips() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Markdown 快速指南：', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(
            '# 标题 | **加粗** | *斜体* | \n- 列表 | > 引用 | \`代码\` | ```代码块```',
            style: TextStyle(fontSize: 11, color: Colors.black54, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewMode() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const SizedBox(),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  _selectedImage,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Text(
                  _titleController.text.isEmpty ? '文章标题' : _titleController.text,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.3),
                ),
                const SizedBox(height: 12),

                // 描述
                if (_descriptionController.text.isNotEmpty)
                  Text(
                    _descriptionController.text,
                    style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
                  ),
                const SizedBox(height: 16),

                // 作者信息
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=200&q=80'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Gragon', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            '发布于 2 小时前 · $_selectedTag',
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Markdown 内容预览
                _buildMarkdownContent(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMarkdownContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(20),
      child: MarkdownBody(
        data: _contentController.text.isEmpty
            ? '# 开始编写\n\n你的 Markdown 内容将在这里预览。'
            : _contentController.text,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          h1: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
            height: 1.5,
          ),
          h1Padding: const EdgeInsets.fromLTRB(0, 20, 0, 12),
          h2: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            height: 1.4,
          ),
          h2Padding: const EdgeInsets.fromLTRB(0, 18, 0, 10),
          h3: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.4,
          ),
          h3Padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
          h4: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          h5: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          h6: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          p: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.8,
          ),
          pPadding: const EdgeInsets.symmetric(vertical: 8),
          em: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontStyle: FontStyle.italic,
          ),
          strong: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          code: TextStyle(
            fontSize: 14,
            fontFamily: 'Courier',
            backgroundColor: Colors.grey[200],
            color: Colors.red[700],
            fontWeight: FontWeight.w500,
          ),
          codeblockDecoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          codeblockPadding: const EdgeInsets.all(16),
          blockquote: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.6,
            fontStyle: FontStyle.italic,
          ),
          blockquoteDecoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.06),
            border: Border(
              left: BorderSide(
                color: Colors.blue[400]!,
                width: 4,
              ),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          blockquotePadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          listBullet: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.8,
          ),
          listBulletPadding: const EdgeInsets.fromLTRB(0, 4, 16, 4),
          listIndent: 24,
          horizontalRuleDecoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey[300]!,
                width: 2,
              ),
            ),
            color: Colors.transparent,
          ),
          a: TextStyle(
            fontSize: 16,
            color: Colors.blue[600],
            decoration: TextDecoration.underline,
          ),
          del: const TextStyle(
            decoration: TextDecoration.lineThrough,
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        onTapLink: (text, href, title) {},
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
