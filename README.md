# Request

一个封装网络请求的 Flutter 项目，包含 `dio` 请求封装、`pretty_dio_logger` 日志打印、`flutter_easyloading` 加载动画、以及数据持久化的 `shared_preferences`。

## 项目简介
该项目旨在简化 Flutter 中的网络请求流程，使用 `dio` 作为主要的网络请求库，并封装了常用的加载状态显示和错误提示。

## 项目结构
- `lib/`: 存放主要的代码文件。
- `lib/utils/`: 包含网络请求封装、请求日志记录等实用工具。
- `lib/pages/`: 包含应用页面。
- `pubspec.yaml`: 包含项目的依赖配置。

## 环境配置

### 1. Flutter SDK 配置
请确保您已安装 Flutter SDK，且版本在 `>=3.2.2 <4.0.0` 范围内。

可以通过运行以下命令检查 Flutter 的安装版本：

```bash
flutter --version
如果您还没有安装 Flutter SDK，请参考 Flutter 官网安装指南 进行安装。

2. 项目依赖
该项目依赖以下包：

dio：用于封装网络请求。
pretty_dio_logger：提供请求日志输出功能。
flutter_easyloading：用于显示加载动画。
shared_preferences：用于数据持久化。
json_serializable 和 json_annotation：用于 JSON 序列化。
启动步骤
1. 克隆项目
从代码仓库克隆该项目：

bash
复制代码
git clone <YOUR_REPO_URL>
cd request
2. 安装依赖
在项目根目录下运行以下命令以安装所需依赖包：

bash
复制代码
flutter pub get
3. 生成 JSON 序列化代码
如果项目中使用了 json_serializable，请运行以下命令生成 *.g.dart 文件：

bash
复制代码
flutter pub run build_runner build
对于持续更新的开发环境，您可以使用以下命令以监听代码更改自动生成文件：

bash
复制代码
flutter pub run build_runner watch
4. 运行项目
确保在 Android Emulator 或连接的设备上启动项目。运行以下命令启动 Flutter 应用：

bash
复制代码
flutter run
依赖包说明
dio：用于发起 HTTP 请求和管理网络响应。
pretty_dio_logger：用于打印请求与响应的详细日志，便于调试。
flutter_easyloading：用于在网络请求中显示加载动画。可以通过 EasyLoading.show() 方法显示加载状态，通过 EasyLoading.dismiss() 隐藏加载框。
shared_preferences：用于数据持久化，将用户数据本地存储。
json_serializable 和 json_annotation：用于将 Dart 对象与 JSON 数据相互转换。
示例代码
使用 flutter_easyloading 显示加载状态
在请求开始时可以调用 showLoading 显示加载框：

dart
复制代码
EasyLoading.show(status: '加载中...');
请求完成后可以调用 dismiss 隐藏加载框：

dart
复制代码
EasyLoading.dismiss();
封装 dio 的请求示例
在 lib/utils/request.dart 文件中可以封装 dio 请求：

dart
复制代码
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class RequestConfig {
  static Dio getDioInstance() {
    Dio dio = Dio();
    dio.interceptors.add(PrettyDioLogger()); // 添加日志拦截器
    return dio;
  }
}
在网络请求方法中调用：

dart
复制代码
Dio dio = RequestConfig.getDioInstance();
var response = await dio.get('https://example.com/api');
本地数据持久化示例
使用 shared_preferences 将数据保存到本地：

dart
复制代码
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<void> saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
注意事项
build_runner：在修改 JSON 相关模型后，需要重新生成代码以确保同步更新。
flutter_easyloading：记得在主文件中调用 EasyLoading.init() 以初始化加载框。
在 pubspec.yaml 中已将 publish_to 设置为 none，表示不发布到 pub.dev，如有需要可移除此行。
常见问题
依赖安装失败：确保 Flutter SDK 和各插件版本兼容。若有冲突，请尝试更新至最新版本或参考官方文档调整。
flutter_easyloading 初始化错误：请确保在 main.dart 中已调用 EasyLoading.init() 。
JSON 序列化失败：使用 build_runner 生成代码，确保模型类包含正确的 json_annotation 注解。
其他说明
项目开发时可以通过 flutter run 启动应用，或者使用 flutter build 命令生成发布版本。
使用 flutter pub outdated 检查依赖包的版本更新情况，以确保依赖包保持最新。
