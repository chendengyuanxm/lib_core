import 'package:flutter/cupertino.dart';
import 'base_state.dart';

abstract class BaseStatefulWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return createBaseState();
  }

  BaseState createBaseState();
}