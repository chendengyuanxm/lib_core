import 'package:lib_core/lib_core.dart';

typedef OnSuccess<T>(T data);
typedef OnError(dynamic e);

class ViewModelHelper {

  execute<T>(Future request, {OnSuccess<T>? onSuccess, OnError? onError}) async {
    try {
      T result = await request;
      if (onSuccess != null) onSuccess(result);
      return result;
    } on HttpRequestException catch (e) {
      if (onError != null) onError(e);
      else handleException(e);
    } on Error catch (e) {
      if (onError != null) onError(e);
      else handleError(e);
    }

    return null;
  }

  executeQueue(List<Future> requests, {Function? onSuccess, OnError? onError}) async {
    try {
      List results = [];
      int i = 0;
      Future.forEach(requests, (request) async {
       results[i++] = await request;
      });
      if (onSuccess != null) onSuccess(results);
      return results;
    } on HttpRequestException catch (e) {
      handleException(e);
      if (onError != null) onError(e);
    } on Error catch (e) {
      handleError(e);
      if (onError != null) onError(e);
    }
  }

  handleException(HttpRequestException e) {
    LogUtil.e(e.toString());
    ToastUtil.showDebug(e.toString());
  }

  handleError(Error e) {
    LogUtil.e(e.toString());
    print(e.stackTrace);
    ToastUtil.show(e.toString());
  }
}