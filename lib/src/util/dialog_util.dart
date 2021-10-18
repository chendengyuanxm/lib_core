import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnSelected<T> = void Function(T item);
typedef PositiveCallback = void Function();
typedef NegativeCallback = void Function();
typedef String ItemAsString<T>(T item);

class DialogUtil {
  static Future<bool> showConfirmDialog(BuildContext context, {
    String? content,
    String? positiveText,
    Function? onConfirm,
    String? negativeText,
    Function? onCancel,
    bool showCancel = true,
  }) async {
    return await showDialog(context: context, builder: (context) => AlertDialog(
      content: Text(content ?? ''),
      actions: [
        Visibility(
          visible: showCancel,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              if (onCancel != null) onCancel();
            },
            child: Text(negativeText ?? '取消'),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            if (onConfirm != null) onConfirm();
          },
          child: Text(positiveText ?? '确定'),
        ),
      ],
    ),);
  }

  static Future showAlertDialog(BuildContext context, {
    String? content,
    String? buttonText,
    Function? onConfirm,
  }) async {
    await showConfirmDialog(context, content: content, positiveText: buttonText, onConfirm: onConfirm, showCancel: false);
  }

  static Future showLoadingDialog(BuildContext context, {String message: 'loading...'}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
            type: MaterialType.transparency,
            child: Center(
              child: SizedBox(
                width: 120.0,
                height: 120.0,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Color(0x00ffffff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                        ),
                        child: Text(
                          message,
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}