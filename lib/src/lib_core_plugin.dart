import 'package:flutter/material.dart';
import 'package:lib_core/lib_core.dart';
import 'package:lib_core/src/toast/i_toast.dart';
import 'package:lib_core/src/i_core_config.dart';
import 'package:lib_core/src/core_const.dart';

/// @author: Devin
/// @date: 2021/10/27 15:26
/// @description:
class LibCorePlugin {
  LibCorePlugin._();

  static init({
    required ICoreConfig coreConfig,
    required IHttpConfig httpConfig,
    IToast? toast,
  }) {
    /// 初始化core config
    CoreConst.coreConfig = coreConfig;
    /// 初始化httpClient
    HttpClient.initConfig(httpConfig);
    /// 初始化toast config
    ToastUtil.init(toast);
  }
}
