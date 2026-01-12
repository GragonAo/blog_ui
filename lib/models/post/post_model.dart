

import 'package:blog_ui/models/user/info.dart';

class Post {
  final String id;
  final String title;
  final UserBaseInfo author;
  final String content;
  final List<String> imageUrl;
  final String tag;
  final String summary;
  final PostStatus status;
  final int likes;
  final int viewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Post({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
    required this.imageUrl,
    required this.tag,
    required this.summary,
    required this.status,
    required this.likes,
    required this.viewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      author: UserBaseInfo.fromJson(json['author']),
      content: json['content'],
      imageUrl: List<String>.from(json['image_url']),
      tag: json['tag'],
      summary: json['summary'],
      status: PostStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == json['status'], 
      orElse: () => PostStatus.draft
    ),
      likes: json['likes'],
      viewCount: json['view_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 8) {
      return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}天前';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
}

enum PostStatus{
  published,
  draft
}

