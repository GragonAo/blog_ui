import 'package:blog_ui/models/post/post_model.dart';
import 'package:blog_ui/utils/platform/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/post_detail_desktop.dart';
import 'components/post_detail_mobile.dart';
import 'components/post_detail_skeleton.dart';

/// 文章详情页面入口
class PostDetailPage extends StatefulWidget {
  final String? postId;

  const PostDetailPage({super.key, this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Post? _post;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPostData();
  }

  Future<void> _loadPostData() async {
    try {
      // 获取路由参数中的 postId
      final postId = widget.postId ?? Get.parameters['id'];
      
      if (postId == null) {
        setState(() {
          _error = '文章ID不存在';
          _isLoading = false;
        });
        return;
      }

      // TODO: 这里应该调用后端 API 获取数据
      // 例如: final post = await PostApi.getPostById(postId);
      
      // 模拟网络请求延迟
      await Future.delayed(const Duration(milliseconds: 500));
      
      // 临时使用 Get.arguments 传递的数据，后期替换为 API 请求
      final post = Get.arguments as Post?;
      
      if (post == null) {
        setState(() {
          _error = '文章不存在';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _post = post;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = '加载失败: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const PostDetailSkeleton();
    }

    if (_error != null || _post == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Get.back(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                _error ?? '文章不存在',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadPostData,
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }

    if (ResponsiveHelper.isDesktop(context)) {
      return PostDetailDesktop(post: _post!);
    } else {
      return PostDetailMobile(post: _post!);
    }
  }
}
