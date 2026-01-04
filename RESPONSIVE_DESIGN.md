# 响应式设计实现说明

## 概述

本项目已实现响应式设计，参考小红书的PC端样式，让应用在PC和移动端有不同的渲染效果。

## 主要特性

### 1. 文章详情页 (PostDetailPage)

#### 移动端 (宽度 ≤ 900px)
- 全屏展示，顶部带Hero动画的大图
- 作者信息叠加在图片底部
- 内容垂直滚动
- 底部固定操作栏

#### PC端 (宽度 > 900px)
- 居中布局，最大宽度1200px
- 左右分栏设计：
  - **左侧主内容区（70%）**：文章图片、标题、内容、互动按钮
  - **右侧边栏（320px）**：作者卡片、推荐阅读
- 白色卡片式设计，圆角和阴影
- 更大的字体和间距，适合阅读

### 2. 首页瀑布流 (HomePage)

#### 移动端 (宽度 ≤ 900px)
- 2列瀑布流布局
- 顶部毛玻璃AppBar
- 搜索栏和标签页
- 底部导航栏

#### PC端 (宽度 > 900px)
- 5列瀑布流布局，最大宽度1400px
- 顶部搜索栏和标签页居中
- 卡片hover效果（悬停上浮）
- 更大的间距和更多内容展示

### 3. 高级Markdown渲染 (AdvancedMarkdownBody)

- 支持基本Markdown语法
- 代码块显示（带暗色主题）
- 引用块样式
- 自定义样式表
- 可选择文本

## 技术实现

### 响应式判断
```dart
final screenWidth = MediaQuery.of(context).size.width;
final isDesktop = screenWidth > 900;
```

### 断点设置
- **移动端**: 0 - 900px
- **PC端**: > 900px

## 文件结构

```
lib/
  views/
    post_detail_page.dart         # 文章详情（响应式）
    home_page.dart                 # 首页（响应式）
    create_post_page.dart          # 创建文章页
    discover_page.dart             # 发现页
    notifications_page.dart        # 通知页
    profile_page.dart              # 个人资料页
  widgets/
    advanced_markdown_body.dart    # Markdown渲染组件
    blog_card.dart                 # 移动端博客卡片
    markdown_editor_toolbar.dart   # Markdown编辑器工具栏
  models/
    post_model.dart                # 文章数据模型
```

## 如何测试

### 测试PC端布局
```bash
# 在Chrome中运行（推荐）
flutter run -d chrome

# 或在macOS桌面应用中运行
flutter run -d macos
```

### 测试移动端布局
```bash
# iOS模拟器
flutter run -d "iPhone 15"

# Android模拟器
flutter run -d android
```

### 在浏览器中调整窗口大小
1. 运行应用后，打开Chrome DevTools (F12)
2. 点击设备模拟器图标
3. 切换不同设备尺寸查看效果
4. 或手动调整浏览器窗口大小

## 设计参考

### 小红书PC端特点
- ✅ 居中内容区域，两侧留白
- ✅ 左右分栏布局（主内容 + 侧边栏）
- ✅ 白色卡片式设计
- ✅ 瀑布流多列布局
- ✅ 悬停交互效果
- ✅ 清晰的视觉层级

### 配色方案
- 背景: `#F5F5F5` (PC) / `#F8F9FA` (移动)
- 卡片: `#FFFFFF`
- 强调色: 红色系（参考小红书品牌色）
- 文字: 黑色系渐变

## 下一步优化建议

1. **平板适配**: 添加中等屏幕（600-900px）的布局
2. **动画优化**: 增加布局切换时的过渡动画
3. **性能优化**: 懒加载图片和内容
4. **主题切换**: 支持暗色模式
5. **更多交互**: 添加评论、分享等功能

## 注意事项

- 确保 `flutter_staggered_grid_view` 包已安装
- 图片URL需要有效才能正常显示
- 在Web端测试时，可能需要禁用CORS限制
