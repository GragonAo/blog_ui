class Post {
  final String id;
  final String title;
  final String author;
  final String authorAvatar;
  final String imageUrl;
  final String tag;
  final String timeAgo;
  final int likes;
  final String description;
  final double imageHeight;
  final String content;

  const Post({
    required this.id,
    required this.title,
    required this.author,
    required this.authorAvatar,
    required this.imageUrl,
    required this.tag,
    required this.timeAgo,
    required this.likes,
    required this.description,
    required this.imageHeight,
    required this.content,
  });
}