// ignore_for_file: must_be_immutable

import 'package:blog_ui/pages/home/home_page.dart';
import 'package:blog_ui/pages/login/view.dart';
import 'package:blog_ui/pages/discover/discover_page.dart';
import 'package:blog_ui/pages/notification/notifications_page.dart';
import 'package:blog_ui/pages/profile/profile_page.dart';
import 'package:blog_ui/pages/post/post_detail_page.dart';
import 'package:blog_ui/widgets/app_layout/app_layout.dart';
import 'package:blog_ui/middlewares/auth_middleware.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:blog_ui/utils/storage.dart';

Box<dynamic> setting = GStrorage.setting;

class Routes {
  static final List<GetPage<dynamic>> getPages = [
    // 首页(推荐)
    CustomGetPage(
      name: '/',
      page: () => const AppLayout(child: HomePage()),
    ),
    // 发现页
    CustomGetPage(
      name: '/discover',
      page: () => const AppLayout(child: DiscoverPage()),
    ),
    // 消息页
    CustomGetPage(
      name: '/notifications',
      page: () => const AppLayout(child: NotificationsPage()),
    ),
    // 个人页
    CustomGetPage(
      name: '/profile',
      page: () => const AppLayout(child: ProfilePage()),
      middlewares: [AuthMiddleware()],
    ),
    // 登录页
    CustomGetPage(name: '/login', page: () => const LoginPage()),
    // 文章详情页
    CustomGetPage(
      name: '/post/:id',
      page: () => const PostDetailPage(),
      fullscreen: true,
    ),
  ];
}

class CustomGetPage extends GetPage<dynamic> {
  CustomGetPage({
    required super.name,
    required super.page,
    this.fullscreen,
    super.middlewares,
    super.transitionDuration = Duration.zero,
  }) : super(
          curve: Curves.linear,
          transition: Transition.noTransition,
          showCupertinoParallax: false,
          popGesture: false,
          fullscreenDialog: fullscreen != null && fullscreen,
        );
  bool? fullscreen = false;
}