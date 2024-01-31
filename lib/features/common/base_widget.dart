import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../enum/app_state.dart';
import 'base_controller.dart';
import 'utils.dart';

abstract class BaseState<W extends StatefulWidget, C extends BaseController>
    extends State<W> with AutomaticKeepAliveClientMixin {
  late final C controller;
  @override
  void initState() {
    super.initState();
    controller = provideController();
    controller.status.listen((state) {
      if (state.state == AppState.failed && state.message != null) {
        Utils.instance.showError(context, message: state.message);
      } else if (state.state == AppState.success && state.message != null) {
        Utils.instance.showSuccess(context, state.message!);
      } else if (state.state == AppState.pop) {
        Navigator.pop(context);
        if (state.message != null) {
          Utils.instance.showError(context, message: state.message);
        }
      }
    });
  }

  @required
  C provideController();

  @override
  void dispose() {
    Get.delete<C>();
    super.dispose();
  }
}
