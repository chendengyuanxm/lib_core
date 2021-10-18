import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class CacheUtil {

  static Future getAppDataSize() async {
    Directory dir = await getApplicationDocumentsDirectory();
    double value = await getTotalSizeOfFilesInDir(dir);
    return value;
  }

  static Future getAppCacheSize() async {
    Directory tempDir = await getTemporaryDirectory();
    double value = await getTotalSizeOfFilesInDir(tempDir);
    return value;
  }

  static Future loadCacheSize() async {
    Directory tempDir = await getTemporaryDirectory();
    double value = await getTotalSizeOfFilesInDir(tempDir);
    return renderSize(value);
  }

  static Future<double> getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      print('[file] ${file.path}');
      return double.parse(length.toString());
    }
    if (file is Directory) {
      print('[dir] ${file.path}');
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  static renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = []
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + ' '+ unitArr[index];
  }

  static Future<void> clearCache() async {
    await DefaultCacheManager().emptyCache();
    Directory tempDir = await getTemporaryDirectory();
    //删除缓存目录
    await _delDir(tempDir);
    Fluttertoast.showToast(msg: '清除缓存成功');
  }

  static Future<void> clearData() async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    //删除缓存目录
    await _delDir(tempDir);
    Fluttertoast.showToast(msg: '清除缓存成功');
  }

  ///递归方式删除目录
  static Future<Null> _delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await _delDir(child);
      }
    }

    try {
      print('[-file] ${file.path}');
      await file.delete();
    } catch (e) {
      print(e);
    }
  }
}