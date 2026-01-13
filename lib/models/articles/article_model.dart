

import 'package:blog_ui/models/user/info.dart';

class Article {
  final String id;
  final String title;
  final UserBaseInfo author;
  final String description;
  final String content;
  final List<String> tags;
  final ArticleStatus status;
  final int likes;
  final int views;
  final String collects;
  final List<String> coverUrls;
  final DateTime  createdAt;
  final DateTime updatedAt;
  DateTime? deletedAt;

  Article({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
    required this.description,
    required this.collects,
    required this.coverUrls,
    required this.tags,
    required this.status,
    required this.likes,
    required this.views,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'].toString(),
      title: json['title'],
      author: json['author'] != null 
          ? UserBaseInfo.fromJson(json['author']) 
          : UserBaseInfo(
              id: json['uid'] is int ? json['uid'] : int.tryParse(json['uid']?.toString() ?? '0') ?? 0,
              username: 'Unknown',
              avatar: null
            ),
      description: json['description'] ?? '',
      collects: json['collects']?.toString() ?? '0',
      content: json['content'] ?? '',
      coverUrls: json['cover_urls'] != null ? List<String>.from(json['cover_urls']) : [],
      tags:  json['tags'] != null ? List<String>.from(json['tags']) : [],
      status: ArticleStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == json['status'], 
      orElse: () => ArticleStatus.draft
    ),
      likes: json['likes'],
      views: json['views'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      
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

enum ArticleStatus{
  public,
  private,
  draft
}

