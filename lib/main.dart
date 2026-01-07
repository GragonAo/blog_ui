import 'dart:io';

import 'package:blog_ui/services/auth_service.dart';
import 'package:blog_ui/services/loggeer.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:hive/hive.dart';
import 'package:blog_ui/common/widgets/custom_toast.dart';
import 'package:blog_ui/http/init.dart';
import 'package:blog_ui/models/common/color_type.dart';
import 'package:blog_ui/models/common/theme_type.dart';
import 'package:blog_ui/router/app_pages.dart';
import 'package:blog_ui/utils/data.dart';
import 'package:blog_ui/utils/global_data_cache.dart';
import 'package:blog_ui/utils/storage.dart';
import 'package:media_kit/media_kit.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 配置 Web URL 策略，移除 # 号
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  
  MediaKit.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GStrorage.init();
  
  // 初始化日志服务
  await loggerService.init();
  
  Request();
  
  // 初始化认证服务
  Get.put(AuthService());

  // 获取 Catcher2 配置
  final catcherConfig = await loggerService.getCatcherConfig();

  Catcher2(
    releaseConfig: catcherConfig,
    runAppFunction: () {
      runApp(const MyApp());
    },
  );

  // 小白条、导航栏沉浸
  if (!kIsWeb && Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 29) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));
  }

  await GlobalDataCache().initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Box setting = GStrorage.setting;
    // 主题色
    Color defaultColor =
        colorThemeTypes[setting.get(SettingBoxKey.customColor, defaultValue: 0)]
            ['color'];
    Color brandColor = defaultColor;
    // 主题模式
    ThemeType currentThemeValue = ThemeType.values[setting
        .get(SettingBoxKey.themeMode, defaultValue: ThemeType.system.code)];
    // 是否动态取色
    bool isDynamicColor =
        setting.get(SettingBoxKey.dynamicColor, defaultValue: true);
    // 字体缩放大小
    double textScale =
        setting.get(SettingBoxKey.defaultTextScale, defaultValue: 1.0);

    // 强制设置高帧率
    if (!kIsWeb && Platform.isAndroid) {
      try {
        late List modes;
        FlutterDisplayMode.supported.then((value) {
          modes = value;
          var storageDisplay = setting.get(SettingBoxKey.displayMode);
          DisplayMode f = DisplayMode.auto;
          if (storageDisplay != null) {
            f = modes.firstWhere((e) => e.toString() == storageDisplay);
          }
          DisplayMode preferred = modes.toList().firstWhere((el) => el == f);
          FlutterDisplayMode.setPreferredMode(preferred);
        });
      } catch (_) {}
    }

    if (!kIsWeb && Platform.isAndroid) {
      return AndroidApp(
        brandColor: brandColor,
        isDynamicColor: isDynamicColor,
        currentThemeValue: currentThemeValue,
        textScale: textScale,
      );
    } else {
      return OtherApp(
        brandColor: brandColor,
        currentThemeValue: currentThemeValue,
        textScale: textScale,
      );
    }
  }
}

class AndroidApp extends StatelessWidget {
  const AndroidApp({
    super.key,
    required this.brandColor,
    required this.isDynamicColor,
    required this.currentThemeValue,
    required this.textScale,
  });

  final Color brandColor;
  final bool isDynamicColor;
  final ThemeType currentThemeValue;
  final double textScale;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: ((ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme? lightColorScheme;
        ColorScheme? darkColorScheme;
        if (lightDynamic != null && darkDynamic != null && isDynamicColor) {
          // dynamic取色成功
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // dynamic取色失败，采用品牌色
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: brandColor,
            brightness: Brightness.light,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: brandColor,
            brightness: Brightness.dark,
          );
        }
        return BuildMainApp(
          lightColorScheme: lightColorScheme,
          darkColorScheme: darkColorScheme,
          currentThemeValue: currentThemeValue,
          textScale: textScale,
        );
      }),
    );
  }
}

class OtherApp extends StatelessWidget {
  const OtherApp({
    super.key,
    required this.brandColor,
    required this.currentThemeValue,
    required this.textScale,
  });

  final Color brandColor;
  final ThemeType currentThemeValue;
  final double textScale;

  @override
  Widget build(BuildContext context) {
    return BuildMainApp(
      lightColorScheme: ColorScheme.fromSeed(
        seedColor: brandColor,
        brightness: Brightness.light,
      ),
      darkColorScheme: ColorScheme.fromSeed(
        seedColor: brandColor,
        brightness: Brightness.dark,
      ),
      currentThemeValue: currentThemeValue,
      textScale: textScale,
    );
  }
}

class BuildMainApp extends StatelessWidget {
  const BuildMainApp({
    super.key,
    required this.lightColorScheme,
    required this.darkColorScheme,
    required this.currentThemeValue,
    required this.textScale,
  });

  final ColorScheme lightColorScheme;
  final ColorScheme darkColorScheme;
  final ThemeType currentThemeValue;
  final double textScale;

  @override
  Widget build(BuildContext context) {
    final SnackBarThemeData snackBarTheme = SnackBarThemeData(
      actionTextColor: lightColorScheme.primary,
      backgroundColor: lightColorScheme.secondaryContainer,
      closeIconColor: lightColorScheme.secondary,
      contentTextStyle: TextStyle(color: lightColorScheme.secondary),
      elevation: 20,
    );

    return GetMaterialApp(
      title: 'blog_ui',
      theme: ThemeData(
        colorScheme: currentThemeValue == ThemeType.dark
            ? darkColorScheme
            : lightColorScheme,
        snackBarTheme: snackBarTheme,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(
              allowEnterRouteSnapshotting: false,
            ),
          },
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: currentThemeValue == ThemeType.light
            ? lightColorScheme
            : darkColorScheme,
        snackBarTheme: snackBarTheme,
      ),
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: const Locale("zh", "CN"),
      supportedLocales: const [Locale("zh", "CN"), Locale("en", "US")],
      fallbackLocale: const Locale("zh", "CN"),
      getPages: Routes.getPages,
      initialRoute: '/',
      builder: (BuildContext context, Widget? child) {
        return FlutterSmartDialog(
          toastBuilder: (String msg) => CustomToast(msg: msg),
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
        );
      },
      navigatorObservers: [
        // SearchPage.routeObserver,
      ],
      onReady: () async {
        Data.init();
      },
    );
  }
}