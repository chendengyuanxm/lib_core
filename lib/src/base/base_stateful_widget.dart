import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'base_state.dart';

abstract class BaseStatefulWidget extends StatefulWidget {

  const BaseStatefulWidget({Key? key, this.checkPermissions}) : super(key: key);

  final List<Permission>? checkPermissions;

  @override
  State<StatefulWidget> createState() {
    return createBaseState();
  }

  BaseState createBaseState();
}