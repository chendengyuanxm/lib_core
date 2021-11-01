import 'package:lib_core/lib_core.dart';

/// @author: Devin
/// @date: 2021/10/27 15:26
/// @description:
class LibCorePlugin {
  LibCorePlugin._();

  static init({
    required IHttpConfig httpConfig,
  }) {
    /// 初始化httpClient
    HttpClient.initConfig(httpConfig);
  }
}
