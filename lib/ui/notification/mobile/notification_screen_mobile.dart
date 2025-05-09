import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreenMobile extends ConsumerStatefulWidget {
  const NotificationScreenMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationScreenMobile> createState() =>
      _NotificationScreenMobileState();
}

class _NotificationScreenMobileState
    extends ConsumerState<NotificationScreenMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final notificationScreenWatch = ref.read(notificationScreenController);
      //notificationScreenWatch.disposeController(isNotify : true);
    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    return Container();
  }


}
