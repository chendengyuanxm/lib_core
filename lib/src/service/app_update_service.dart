import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:flutter_xupdate/update_entity.dart' as xupdate;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lib_core/lib_core.dart';
import 'package:lib_core/src/core_const.dart';
import 'package:lib_core/src/util/index.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lib_core/src/ext/string_extensions.dart';
import 'package:lib_core/src/net/http_client.dart' as http;

typedef OnUpdateParser = UpdateEntity Function(String json);
typedef PerformDownload = Function();
typedef OnShowDownloadDialog = Function(UpdateEntity version, PerformDownload performDownload);

class UpdateEntity {
  int versionCode;
  String? versionName;
  String? downloadUrl;
  String? updateContent;
  int? size;
  bool? isForce;

  UpdateEntity({required this.versionCode, this.versionName, this.downloadUrl, this.updateContent, this.size, this.isForce,});
}

class UpdateDialogStyle {
  Color? primaryColor;
  String? topImageRes;
  UpdateDialogStyle({this.primaryColor, this.topImageRes});
}

class AppUpdateService {
  late BuildContext context;
  bool silent = false;
  bool alwaysCheck = true;
  String? url;
  Map<String, dynamic>? param;
  String method = 'GET';
  String? appleStoreUrl;
  UpdateDialogStyle? updateDialogStyle;
  String apkName = '';
  UpdateEntity? version;

  OnUpdateParser? onUpdateParser;
  OnShowDownloadDialog? onShowDownloadDialog;

  final String downloadPath = '/storage/emulated/0/Download/';

  init({
    String? appleStoreUrl,
    bool silent = false,
    bool alwaysCheck = true,
    UpdateDialogStyle? updateDialogStyle,
  }) {
    this.silent = silent;
    this.alwaysCheck = alwaysCheck;
    this.appleStoreUrl = appleStoreUrl;
    this.updateDialogStyle = updateDialogStyle;
    initXUpdate();
  }

  initXUpdate() async {
    await FlutterXUpdate.init(
      debug: true,
      timeout: 30000,
      enableRetry: true,
    );
    FlutterXUpdate.setErrorHandler(onUpdateError: (Map<String, dynamic>? message) async {
      ToastUtil.showDebug("$message}");
    });
  }

  setUpdateHandler({OnUpdateParser? onUpdateParser, OnShowDownloadDialog? onShowDownloadDialog}) {
    this.onUpdateParser = onUpdateParser;
    this.onShowDownloadDialog = onShowDownloadDialog;
  }

  checkUpdate(BuildContext context, {
    required String url,
    Map<String, dynamic>? param,
    String method = 'GET',
    bool silent = false,
    bool alwaysCheck = true,
  }) async {
    LogUtil.i('check update');
    this.context = context;
    this.silent = silent;
    this.alwaysCheck = alwaysCheck;
    this.url = url;
    this.param = param;
    this.method = method;
    num timeStamp = DateTime.now().millisecondsSinceEpoch;
    num lastTimeStamp = await SharedPreference.getInt('lastUpdateTime') ?? 0;
    if (alwaysCheck || timeStamp - lastTimeStamp >= 24 * 60 * 60 * 1000) {
      await _checkUpdate();
    }
  }

  _checkUpdate() async {
    if (Platform.isIOS && appleStoreUrl.isNotNullAndEmpty) {
      await launch(appleStoreUrl!, forceSafariVC: false);
    } else if (Platform.isAndroid) {
      await _getNewVersion();
    }
  }

  _getNewVersion() async {
    HttpResult? result;
    try {
      if (method == 'GET') {
        result = await http.HttpClient().get<dynamic>(url!, param??{}, isShowProgress: !silent);
      } else {
        result = await http.HttpClient().post<dynamic>(url!, {}, body: param, isShowProgress: !silent);
      }
    } catch (e) {
      LogUtil.e(e);
      Fluttertoast.showToast(msg: '获取更新版本失败');
    }

    if (result == null || !result.success)
      return;

    String json = jsonEncode(result.data);
    version = onUpdateParser?.call(json);
    if (version != null) {
      apkName = 'app-${version!.versionCode}-${DateTime.now().millisecondsSinceEpoch}.apk';
      await _checkVersionCode();
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      await SharedPreference.setInt('lastUpdateTime', timeStamp);
    } else {
      Fluttertoast.showToast(msg: '暂无更新信息');
    }
  }

  _checkVersionCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String _currentVersionCode = packageInfo.buildNumber;
    int serviceVersionCode = version!.versionCode;
    int currentVersionCode = int.parse(_currentVersionCode);
    LogUtil.i('serviceVersionCode: $serviceVersionCode , currentVersionCode: $currentVersionCode');
    if (serviceVersionCode > currentVersionCode) {
      // _showUpdateDialog();
      xupdate.UpdateEntity updateEntity = xupdate.UpdateEntity(
        hasUpdate: true,
        isForce: version!.isForce,
        downloadUrl: version!.downloadUrl,
        versionCode: version!.versionCode,
        versionName: version!.versionName,
        updateContent: version!.updateContent,
        apkSize: (version!.size??0)~/1024,
      );
      String colorString = this.updateDialogStyle?.primaryColor != null ? '#${this.updateDialogStyle?.primaryColor!.value.toRadixString(16).padLeft(8, '0')}' : '';
      await FlutterXUpdate.updateByInfo(
        updateEntity: updateEntity,
        supportBackgroundUpdate: true,
        themeColor: colorString,
        topImageRes: this.updateDialogStyle?.topImageRes ?? '',
        widthRatio: 0.8,
      );
    } else if (!silent) {
      Fluttertoast.showToast(msg: '当前已是最新版本！');
    }
  }

  _showUpdateDialog() async {
    onShowDownloadDialog?.call(version!, _performUpdate);
  }

  _performUpdate() async {
    if (await _requestPermission()) {
      await _executeDownload();
    }
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> permissionStatuses = await [Permission.storage].request();
    if (permissionStatuses.values.every((status) => status.isGranted)) {
      return true;
    }
    return false;
  }

  /// 创建下载目录
  _executeDownload() async {
    _apkLocalPath = await _localPath;

    final path = await _apkLocalPath;
    File file = File(path + apkName);
    if (await file.exists()) {
      LogUtil.i('delete ${file.path}');
      await file.delete();
      // await _installApk(path, apkName);
    }

    _downloadFile(version!.downloadUrl, _apkLocalPath, apkName);
  }

  /// 下载APK文件
  _downloadFile(downloadUrl, savePath, apkName) async {
    LogUtil.i('download url: $downloadUrl  save path: $savePath  apkName: $apkName');
    ProgressDialog pr = ProgressDialog(context: context);
    if (!pr.isOpen()) {
      pr.show(max: 100, msg: '下载中...');
    }

    // 必须先于enqueue执行
    FlutterDownloader.registerCallback(downloadCallback, step: 1);

    await FlutterDownloader.cancelAll();
    final taskId = await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: savePath,
      showNotification: true,
      fileName: apkName,
      // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );

    ReceivePort _receivePort = ReceivePort();
    bool succ = IsolateNameServer.registerPortWithName(_receivePort.sendPort, 'downloader_send_port');
    if (!succ) {
      IsolateNameServer.removePortNameMapping('downloader_send_port');
      succ = IsolateNameServer.registerPortWithName(_receivePort.sendPort, 'downloader_send_port');
    }
    _receivePort.listen((data) {
      String id = data[0];
      int status = data[1];
      int progress = data[2];
      LogUtil.i('[Download] $id , ${status} , $progress');
      if (status == DownloadTaskStatus.running.value) {
        pr.update(value: progress, msg: "下载中，请稍后…");
      }

      if (status == DownloadTaskStatus.failed.value) {
        Fluttertoast.showToast(msg: "下载异常，请稍后重试");
        LogUtil.e("下载异常，请稍后重试");
        if (pr.isOpen()) {
          pr.close();
          IsolateNameServer.removePortNameMapping('downloader_send_port');
        }
      }

      if (taskId == id && status == DownloadTaskStatus.complete.value) {
        Fluttertoast.showToast(msg: "下载完成!");
        LogUtil.i("下载完成!");
        if (pr.isOpen()) {
          pr.close();
          IsolateNameServer.removePortNameMapping('downloader_send_port');
        }

        Future.delayed(Duration(seconds: 1), () => _installApk(savePath, apkName));
      }
    });
  }

  @pragma('vm:entry-point')
  static downloadCallback(String id, int status, int progress) {
    final SendPort? sendPort = IsolateNameServer.lookupPortByName('downloader_send_port');
    sendPort?.send([id, status, progress]);
  }

  /// 安装apk
  Future<Null> _installApk(String path, String name) async {
    String apkPath = downloadPath + apkName;
    LogUtil.i('Install apk: $apkPath');
    File apk = File(apkPath);
    if (!apk.existsSync()) {
      Fluttertoast.showToast(msg: '文件不存在，请重新下载');
      return;
    }
    var result = await OpenFile.open(apk.path);
    LogUtil.i('install result: ${result.type}');
  }

  var _apkLocalPath;

  Future<String> get _localPath async {
    String externalStorageDirPath;

    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (err, st) {
        print('failed to get downloads path: $err, $st');

        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path??'';
      }
    } else {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }
}