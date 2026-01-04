// ignore_for_file: must_be_immutable

import 'package:blog_ui/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:blog_ui/utils/storage.dart';

Box<dynamic> setting = GStrorage.setting;

class Routes {
  static final List<GetPage<dynamic>> getPages = [
    // 首页(推荐)
    CustomGetPage(name: '/', page: () => const HomePage()),
  ];
}

class CustomGetPage extends GetPage<dynamic> {
  CustomGetPage({
    required super.name,
    required super.page,
    this.fullscreen,
    super.transitionDuration,
  }) : super(
          curve: Curves.linear,
          transition: Transition.native,
          showCupertinoParallax: false,
          popGesture: false,
          fullscreenDialog: fullscreen != null && fullscreen,
        );
  bool? fullscreen = false;
}