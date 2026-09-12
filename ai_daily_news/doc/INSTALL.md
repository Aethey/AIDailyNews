# Flutter Firebase Analytics 安装指南

适用环境：

- macOS
- Flutter
- Firebase Analytics
- Web + Android + iOS

目标：从一个已有 Flutter 项目开始，完成 Firebase Analytics 的三端配置。

---

## 1. 进入 Flutter 项目

```bash
cd /你的/Flutter/项目目录
```

例如：

```bash
cd ~/WorkSpace/Flutter/my_app
```

确认 Flutter 可用：

```bash
flutter --version
```

---

## 2. 安装 Flutter Firebase 依赖

在 Flutter 项目根目录执行：

```bash
flutter pub add firebase_core
flutter pub add firebase_analytics
```

安装完成后，`pubspec.yaml` 中会自动增加对应依赖。

---

## 3. 安装 FlutterFire CLI

执行：

```bash
dart pub global activate flutterfire_cli
```

临时加入 PATH：

```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
```

确认：

```bash
flutterfire --version
```

### 永久加入 PATH

避免每次打开 Terminal 都重新执行 `export`：

```bash
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc
```

再次确认：

```bash
flutterfire --version
```

---

## 4. 安装 Firebase 官方 CLI

FlutterFire CLI 依赖 Firebase CLI。

先确认 Node.js / npm：

```bash
node --version
npm --version
```

如果都能正常显示版本号，执行：

```bash
npm install -g firebase-tools
```

确认：

```bash
firebase --version
```

---

## 5. 登录 Firebase

执行：

```bash
firebase login
```

浏览器会打开 Google 登录页面。

使用拥有目标 Firebase Project 权限的 Google 账号登录。

登录完成后检查项目：

```bash
firebase projects:list
```

找到你要使用的：

```text
Project ID
```

后续命令中使用：

```text
YOUR_FIREBASE_PROJECT_ID
```

替代真实 Project ID。

---

## 6. iOS / macOS：确认 xcodeproj

如果需要配置 iOS，先执行：

```bash
ruby -e 'require "xcodeproj"; puts Xcodeproj::VERSION'
```

如果正常显示版本号，例如：

```text
1.28.1
```

可以直接进入下一步。

如果报错：

```text
cannot load such file -- xcodeproj
```

安装：

```bash
sudo gem install xcodeproj
```

安装后重新确认：

```bash
ruby -e 'require "xcodeproj"; puts Xcodeproj::VERSION'
```

### 如果 macOS 系统 Ruby 太旧导致安装失败

安装 Homebrew Ruby：

```bash
brew install ruby
```

Apple Silicon Mac：

```bash
echo 'export PATH="/opt/homebrew/opt/ruby/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

确认：

```bash
which ruby
ruby --version
```

然后：

```bash
gem install xcodeproj
```

再次确认：

```bash
ruby -e 'require "xcodeproj"; puts Xcodeproj::VERSION'
```

---

## 7. 配置 FlutterFire

确保当前目录是 Flutter 项目根目录：

```bash
cd /你的/Flutter/项目目录
```

执行：

```bash
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

例如：

```bash
flutterfire configure --project=xxxxxxxx
```

出现平台选择时，选择：

```text
android
ios
web
```

操作方式：

```text
↑ ↓     移动
Space   选择 / 取消
Enter   确认
```

第一次配置时，FlutterFire 可能自动在 Firebase Project 中注册：

```text
Android App
iOS App
Web App
```

这是正常行为。

成功后应该看到：

```text
Firebase configuration file lib/firebase_options.dart generated successfully
```

确认文件存在：

```bash
ls lib/firebase_options.dart
```

---

## 8. 初始化 Firebase

打开：

```text
lib/main.dart
```

加入：

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
```

关键代码：

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

`DefaultFirebaseOptions.currentPlatform` 会自动根据当前运行平台选择：

```text
Web
Android
iOS
```

对应的 Firebase 配置。

---

## 9. 添加一个 Analytics 测试事件

导入：

```dart
import 'package:firebase_analytics/firebase_analytics.dart';
```

发送测试事件：

```dart
await FirebaseAnalytics.instance.logEvent(
  name: 'test_event',
);
```

例如：

```dart
ElevatedButton(
  onPressed: () async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'test_event',
    );
  },
  child: const Text('Test Analytics'),
)
```

---

## 10. 测试 Web

查看设备：

```bash
flutter devices
```

启动 Chrome：

```bash
flutter run -d chrome
```

打开页面并触发：

```text
test_event
```

---

## 11. 测试 Android

查看 Android 设备：

```bash
flutter devices
```

运行：

```bash
flutter run
```

或者指定设备：

```bash
flutter run -d YOUR_ANDROID_DEVICE_ID
```

---

## 12. 测试 iOS

先检查环境：

```bash
flutter doctor
```

查看设备：

```bash
flutter devices
```

运行：

```bash
flutter run
```

或者指定模拟器：

```bash
flutter run -d "iPhone 17"
```

---

# 常见错误

## 错误 1：FlutterFire 找不到 Firebase CLI

报错类似：

```text
The FlutterFire CLI currently requires the official Firebase CLI
```

解决：

```bash
npm install -g firebase-tools
```

确认：

```bash
firebase --version
```

然后：

```bash
firebase login
```

---

## 错误 2：Found 0 Firebase projects

先确认是否已经登录：

```bash
firebase login
```

然后：

```bash
firebase projects:list
```

如果能看到目标项目，再执行：

```bash
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

---

## 错误 3：cannot load such file -- xcodeproj

安装：

```bash
sudo gem install xcodeproj
```

验证：

```bash
ruby -e 'require "xcodeproj"; puts Xcodeproj::VERSION'
```

---

# 已配置过电脑后的最短流程

如果本机已经安装过：

- FlutterFire CLI
- Firebase CLI
- xcodeproj

那么以后新 Flutter 项目只需要：

```bash
cd YOUR_FLUTTER_PROJECT

flutter pub add firebase_core
flutter pub add firebase_analytics

flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

然后在 `main.dart` 初始化：

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
```

---

# 新 Mac 一次性安装顺序

下面按顺序执行即可：

```bash
# 1. Flutter Firebase dependencies
flutter pub add firebase_core
flutter pub add firebase_analytics

# 2. FlutterFire CLI
dart pub global activate flutterfire_cli

echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc

flutterfire --version

# 3. Firebase CLI
npm install -g firebase-tools

firebase --version

# 4. Firebase login
firebase login

# 5. 查看 Firebase Projects
firebase projects:list

# 6. iOS dependency
sudo gem install xcodeproj

ruby -e 'require "xcodeproj"; puts Xcodeproj::VERSION'

# 7. Configure Flutter Firebase
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

平台选择：

```text
Android
iOS
Web
```

最后确认：

```bash
ls lib/firebase_options.dart
```

如果输出：

```text
lib/firebase_options.dart
```

Firebase 基础配置完成。

---

# 建议的 Analytics 事件

对于内容 / 新闻类 App，第一版可以先使用：

```text
home_open
article_open
article_read_complete
original_link_click
category_open
```

例如：

```dart
await FirebaseAnalytics.instance.logEvent(
  name: 'article_open',
  parameters: {
    'article_id': article.id,
    'title': article.title,
  },
);
```

Firebase Analytics 不要求 App 用户登录，也可以正常进行匿名行为统计。
