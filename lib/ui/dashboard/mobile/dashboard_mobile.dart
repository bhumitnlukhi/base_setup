import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardMobile extends ConsumerStatefulWidget {
  const DashboardMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardMobile> createState() => _DashboardMobileState();
}

class _DashboardMobileState extends ConsumerState<DashboardMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final dashboardWatch = ref.watch(dashboardController);
      //dashboardWatch.disposeController(isNotify : true);
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
