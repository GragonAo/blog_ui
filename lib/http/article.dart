import 'package:dio/dio.dart';
import 'package:blog_ui/http/index.dart';
import 'package:blog_ui/models/articles/article_model.dart';
import 'package:blog_ui/http/api.dart';

class ArticleHttp {
  /// 创建文章
  static Future<int> createArticle({
    required String title,
    required String description,
    required String content,
    List<String>? coverUrls,
  }) async {
    final res = await Request().post(
      Api.blogArticleCreate,
      data: {
        'title': title,
        'description': description,
        'content': content,
        'cover_urls': coverUrls ?? [],
      },
      options: Options(contentType: Headers.jsonContentType),
    );
    if (res.data['code'] == 0 || res.data['code'] == 200) {
      return res.data['data'];
    } else {
      throw res.data['message'];
    }
  }

  /// 更新文章
  static Future<void> updateArticle({
    required String id,
    required String title,
    required String description,
    required String content,
    List<String>? coverUrls,
  }) async {
    final res = await Request().put(
      Api.blogArticleUpdate,
      data: {
        'id': int.parse(id),
        'title': title,
        'description': description,
        'content': content,
        'cover_urls': coverUrls ?? [],
      },
      options: Options(contentType: Headers.jsonContentType),
    );
    if (res.data['code'] != 0 && res.data['code'] != 200) {
      throw res.data['message'];
    }
  }

  /// 删除文章
  static Future<void> deleteArticle(String id) async {
    final res = await Request().delete(
      '${Api.blogArticleDelete}/$id',
    );
    if (res.data['code'] != 0 && res.data['code'] != 200) {
      throw res.data['message'];
    }
  }

  /// 获取文章详情
  static Future<Article> getArticleDetail(String id) async {
    final res = await Request().get(
      '${Api.blogArticleDetail}/$id',
    );
    if (res.data['code'] == 0 || res.data['code'] == 200) {
      return Article.fromJson(res.data['data']);
    } else {
      throw res.data['message'];
    }
  }

  /// 获取文章列表
  static Future<ArticlePageResult> getArticleList({
    ArticleQuery? query,
    required int page,
    required int pageSize,
  }) async {
    final res = await Request().get(
      Api.blogArticleList,
      data: {
        ...?query?.toJson(),
        'page_num': page,
        'page_size': pageSize,
      },
    );
    if (res.data['code'] == 0 || res.data['code'] == 200) {
      return ArticlePageResult.fromJson(res.data['data']);
    } else {
      throw res.data['message'];
    }
  }
}

class ArticleQuery {
  final String? keyword;
  final String? status;

  ArticleQuery({this.keyword, this.status});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (keyword != null) data['keyword'] = keyword;
    if (status != null) data['status'] = status;
    return data;
  }
}

class ArticlePageResult {
  final List<Article> list;
  final int total;
  final int pageNum;
  final int pageSize;

  ArticlePageResult({
    required this.list,
    required this.total,
    required this.pageNum,
    required this.pageSize,
  });

  factory ArticlePageResult.fromJson(Map<String, dynamic> json) {
    return ArticlePageResult(
      list: (json['list'] as List).map((e) => Article.fromJson(e)).toList(),
      total: json['total'],
      pageNum: json['page_num'],
      pageSize: json['page_size'],
    );
  }
}
