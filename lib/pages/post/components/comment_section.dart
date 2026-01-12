import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// 评论区组件
class CommentSection extends StatefulWidget {
  final int commentCount;
  final bool isDesktop;

  const CommentSection({
    super.key,
    this.commentCount = 0,
    this.isDesktop = false,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  final List<Comment> _comments = [
    Comment(
      id: 'c1',
      userName: '小李同学',
      userAvatar: 'https://i.pravatar.cc/150?img=1',
      content: '写得真好，很有帮助！期待更多这样的内容。',
      timeAgo: '2小时前',
      likes: 24,
    ),
    Comment(
      id: 'c2',
      userName: '技术小白',
      userAvatar: 'https://i.pravatar.cc/150?img=2',
      content: '讲解得很清晰，学到了很多，感谢分享！',
      timeAgo: '5小时前',
      likes: 18,
    ),
    Comment(
      id: 'c3',
      userName: '前端开发者',
      userAvatar: 'https://i.pravatar.cc/150?img=3',
      content: '这个方案确实不错，我在项目中也遇到过类似的问题。',
      timeAgo: '1天前',
      likes: 32,
    ),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.isDesktop ? 32 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: widget.isDesktop ? BorderRadius.circular(16) : null,
        boxShadow: widget.isDesktop
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 评论标题
          Row(
            children: [
              Text(
                '评论',
                style: TextStyle(
                  fontSize: widget.isDesktop ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_comments.length}',
                style: TextStyle(
                  fontSize: widget.isDesktop ? 18 : 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: widget.isDesktop ? 24 : 20),

          // 评论输入框
          _buildCommentInput(),

          SizedBox(height: widget.isDesktop ? 32 : 24),

          // 评论列表
          if (_comments.isEmpty)
            _buildEmptyState()
          else
            ..._comments.map((comment) => _buildCommentItem(comment)).toList(),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(widget.isDesktop ? 12 : 10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          TextField(
            controller: _commentController,
            maxLines: widget.isDesktop ? 4 : 3,
            decoration: InputDecoration(
              hintText: '写下你的评论...',
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: widget.isDesktop ? 15 : 14,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(widget.isDesktop ? 16 : 12),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              widget.isDesktop ? 16 : 12,
              0,
              widget.isDesktop ? 16 : 12,
              widget.isDesktop ? 12 : 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        LucideIcons.smile,
                        size: widget.isDesktop ? 20 : 18,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {},
                      tooltip: '表情',
                    ),
                    IconButton(
                      icon: Icon(
                        LucideIcons.image,
                        size: widget.isDesktop ? 20 : 18,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {},
                      tooltip: '图片',
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      // TODO: 提交评论
                      _commentController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('评论已发送')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.isDesktop ? 24 : 20,
                      vertical: widget.isDesktop ? 12 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widget.isDesktop ? 10 : 8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    '发送',
                    style: TextStyle(
                      fontSize: widget.isDesktop ? 14 : 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.isDesktop ? 24 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像
          CircleAvatar(
            radius: widget.isDesktop ? 20 : 18,
            backgroundImage: NetworkImage(comment.userAvatar),
          ),
          SizedBox(width: widget.isDesktop ? 12 : 10),
          // 评论内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.userName,
                      style: TextStyle(
                        fontSize: widget.isDesktop ? 15 : 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment.timeAgo,
                      style: TextStyle(
                        fontSize: widget.isDesktop ? 13 : 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: widget.isDesktop ? 8 : 6),
                Text(
                  comment.content,
                  style: TextStyle(
                    fontSize: widget.isDesktop ? 14 : 13,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: widget.isDesktop ? 12 : 10),
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.heart,
                            size: widget.isDesktop ? 16 : 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${comment.likes}',
                            style: TextStyle(
                              fontSize: widget.isDesktop ? 13 : 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: widget.isDesktop ? 20 : 16),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        '回复',
                        style: TextStyle(
                          fontSize: widget.isDesktop ? 13 : 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: widget.isDesktop ? 60 : 40),
        child: Column(
          children: [
            Icon(
              LucideIcons.messageSquare,
              size: widget.isDesktop ? 48 : 40,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: widget.isDesktop ? 16 : 12),
            Text(
              '还没有评论',
              style: TextStyle(
                fontSize: widget.isDesktop ? 16 : 14,
                color: Colors.grey.shade500,
              ),
            ),
            SizedBox(height: widget.isDesktop ? 8 : 6),
            Text(
              '来发表第一条评论吧~',
              style: TextStyle(
                fontSize: widget.isDesktop ? 14 : 12,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 评论数据模型
class Comment {
  final String id;
  final String userName;
  final String userAvatar;
  final String content;
  final String timeAgo;
  final int likes;

  Comment({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.timeAgo,
    required this.likes,
  });
}
