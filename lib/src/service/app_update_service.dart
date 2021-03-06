import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lib_core/lib_core.dart';
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

class AppUpdateService {
  late BuildContext context;
  bool silent = false;
  bool alwaysCheck = true;
  String? url;
  Map<String, dynamic>? param;
  String method = 'GET';
  String? appleStoreUrl;
  String apkName = '';
  UpdateEntity? version;

  OnUpdateParser? onUpdateParser;
  OnShowDownloadDialog? onShowDownloadDialog;

  final String downloadPath = '/storage/emulated/0/Download/';

  init({
    String? appleStoreUrl,
    bool silent = false,
    bool alwaysCheck = true,
  }) {
    this.silent = silent;
    this.alwaysCheck = alwaysCheck;
    this.appleStoreUrl = appleStoreUrl;
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
  }) async {
    LogUtil.v('check update');
    this.context = context;
    this.silent = silent;
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
        result = await http.HttpClient().get<dynamic>(url!, param??{});
      } else {
        result = await http.HttpClient().get<dynamic>(url!, param??{});
      }
    } catch (e) {
      LogUtil.e(e);
      Fluttertoast.showToast(msg: '????????????????????????');
    }

    if (result == null || !result.success)
      return;

    String json = jsonEncode(result.data);
    version = onUpdateParser?.call(json);
    if (version != null) {
      apkName = 'xmcg-${version!.versionName}.apk';
      await _checkVersionCode();
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      await SharedPreference.setInt('lastUpdateTime', timeStamp);
    } else {
      Fluttertoast.showToast(msg: '??????????????????');
    }
  }

  _checkVersionCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String _currentVersionCode = packageInfo.buildNumber;
    int serviceVersionCode = version!.versionCode;
    int currentVersionCode = int.parse(_currentVersionCode);
    LogUtil.v('serviceVersionCode: $serviceVersionCode , currentVersionCode: $currentVersionCode');
    if (serviceVersionCode > currentVersionCode) {
      _showUpdateDialog();
    } else if (!silent) {
      Fluttertoast.showToast(msg: '???????????????????????????');
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

  /// ??????????????????
  _executeDownload() async {
    _apkLocalPath = await _localPath;

    final path = await _apkLocalPath;
    File file = File(downloadPath + apkName);
    if (await file.exists()) {
      // await file.delete();
      await _installApk(path, apkName);
      return;
    }

    _downloadFile(version!.downloadUrl, _apkLocalPath, apkName);
  }

  /// ??????APK??????
  _downloadFile(downloadUrl, savePath, apkName) async {
    LogUtil.i('download url: $downloadUrl  save path: $savePath');
    ProgressDialog pr = ProgressDialog(context: context);
    if (!pr.isOpen()) {
      pr.show(max: 100, msg: '?????????...');
    }

    // ????????????enqueue??????
    FlutterDownloader.registerCallback(downloadCallback);

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
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      LogUtil.i('[Download] $id , ${status.value} , $progress');
      if (status == DownloadTaskStatus.running) {
        pr.update(value: progress, msg: "????????????????????????");
      }

      if (status == DownloadTaskStatus.failed) {
        Fluttertoast.showToast(msg: "??????????????????????????????");
        LogUtil.e("??????????????????????????????");
        if (pr.isOpen()) {
          pr.close();
        }
      }

      if (taskId == id && status == DownloadTaskStatus.complete) {
        Fluttertoast.showToast(msg: "????????????!");
        LogUtil.i("????????????!");
        if (pr.isOpen()) {
          pr.close();
        }

        Future.delayed(Duration(seconds: 1), () => _installApk(savePath, apkName));
      }
    });
  }

  static downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? sendPort = IsolateNameServer.lookupPortByName('downloader_send_port');
    sendPort?.send([id, status, progress]);
  }

  /// ??????apk
  Future<Null> _installApk(String path, String name) async {
    String apkPath = downloadPath + apkName;
    LogUtil.i('Install apk: $apkPath');
    File apk = File(apkPath);
    if (!apk.existsSync()) {
      Fluttertoast.showToast(msg: '?????????????????????????????????');
      return;
    }
    await OpenFile.open(apk.path);
  }

  var _apkLocalPath;

  Future<String> get _localPath async {
    final directory = Theme
        .of(context)
        .platform == TargetPlatform.android
        ? await getTemporaryDirectory()
        : await getApplicationSupportDirectory();
    return directory.path;
  }
}